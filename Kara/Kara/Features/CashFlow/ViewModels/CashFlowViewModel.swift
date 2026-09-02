import Foundation
import Combine

public class CashFlowViewModel: ObservableObject {
    @Published private var allTransactions: [CashFlowModel] = []
    @Published public var transactions: [CashFlowModel] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    
    @Published public var selectedDate: Date = Date()
    @Published public var searchText: String = ""
    @Published public var selectedPaymentStatus: PaymentStatus? = nil
    @Published var selectedCategory: CategoryFilterOption? = nil
    @Published public var useCustomDateRange: Bool = false
    @Published public var startDate: Date = Date()
    @Published public var endDate: Date = Date()
    @Published public var minAmountFilter: String = ""
    @Published public var maxAmountFilter: String = ""
    
    private let service = APIService.shared
    
    public init() {
        syncMonthDateRange()
    }
    
    public var selectedMonthYearString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }
    
    public var totalIncome: Double {
        transactions
            .filter { $0.type == .salesNote }
            .reduce(0) { $0 + $1.amount }
    }
    
    public var totalExpense: Double {
        transactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
    
    public var groupedTransactions: [(key: Date, value: [CashFlowModel])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: transactions) { item in
            calendar.startOfDay(for: item.occurredAt)
        }
        return grouped.sorted { $0.key > $1.key }
    }
    
    public func nextMonth() {
        if let next = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) {
            selectedDate = next
            useCustomDateRange = false
            syncMonthDateRange()
            applyFilters()
        }
    }
    
    public func previousMonth() {
        if let prev = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) {
            selectedDate = prev
            useCustomDateRange = false
            syncMonthDateRange()
            applyFilters()
        }
    }
    
    private var fetchTask: Task<Void, Never>?

    @MainActor
    public func loadTransactions(shopId: UUID) async {
        fetchTask?.cancel()
        
        fetchTask = Task {
            if allTransactions.isEmpty {
                isLoading = true
            }
            errorMessage = nil
             
            do {
                let fetchedData = try await service.fetchCashFlows(shopId: shopId)
                
                if Task.isCancelled { return }
                
                print("DEBUG: Refresh/Fetch Sukses, jumlah: \(fetchedData.count)")
                self.allTransactions = fetchedData
                applyFilters()
                self.isLoading = false
            } catch {
                if Task.isCancelled { return }
                
                self.isLoading = false
                let errorString = error.localizedDescription.lowercased()
                
                if error is CancellationError || errorString.contains("cancel") || (error as NSError).code == -999 {
                    print("DEBUG: Request dibatalkan (-999)")
                    return
                }
                
                self.errorMessage = error.localizedDescription
            }
        }
        _ = await fetchTask?.result
    }

    public func applyFilters() {
        let calendar = Calendar.current
        let normalizedStartDate = calendar.startOfDay(for: useCustomDateRange ? startDate : monthStartDate(for: selectedDate))
        let normalizedEndDate = calendar.startOfDay(for: useCustomDateRange ? endDate : monthEndDate(for: selectedDate))
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let minAmount = Double(minAmountFilter.replacingOccurrences(of: ",", with: "")) ?? 0
        let maxAmount = Double(maxAmountFilter.replacingOccurrences(of: ",", with: "")) ?? .greatestFiniteMagnitude
        
        transactions = allTransactions.filter { transaction in
            let transactionDay = calendar.startOfDay(for: transaction.occurredAt)
            
            guard transactionDay >= normalizedStartDate, transactionDay <= normalizedEndDate else {
                return false
            }
            
            guard transaction.amount >= minAmount, transaction.amount <= maxAmount else {
                return false
            }
            
            if let selectedCategory {
                switch selectedCategory {
                case .all:
                    break
                case .incomeStatus:
                    guard transaction.type == .salesNote else { return false }
                case .expenseItem(let category):
                    guard transaction.type == .expense else { return false }
                    
                    let categoryName = transaction.categoryType
                    guard categoryName.lowercased() == category.name.lowercased() else { return false }
                }
            }
            
            guard !query.isEmpty else {
                return true
            }
            
            let searchableText = [
                transaction.title,
                transaction.description,
                transaction.categoryType,
                String(Int(transaction.amount))
            ]
            .compactMap { $0 }
            .joined(separator: " ")
            .lowercased()
            
            return searchableText.contains(query)
        }
    }
    
    public func resetFilters() {
        searchText = ""
        selectedPaymentStatus = nil
        selectedCategory = nil
        useCustomDateRange = false
        minAmountFilter = ""
        maxAmountFilter = ""
        syncMonthDateRange()
        applyFilters()
    }
    
    private func syncMonthDateRange() {
        startDate = monthStartDate(for: selectedDate)
        endDate = monthEndDate(for: selectedDate)
    }
    
    private func monthStartDate(for date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components) ?? date
    }
    
    private func monthEndDate(for date: Date) -> Date {
        let calendar = Calendar.current
        guard
            let nextMonth = calendar.date(byAdding: .month, value: 1, to: monthStartDate(for: date)),
            let end = calendar.date(byAdding: .day, value: -1, to: nextMonth)
        else {
            return date
        }
        return end
    }
}
