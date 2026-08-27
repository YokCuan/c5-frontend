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
    
    private let service = FirebaseService.shared
    
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
            .filter { $0.type == .pemasukan }
            .reduce(0) { $0 + $1.amount }
    }
    
    public var totalExpense: Double {
        transactions
            .filter { $0.type == .pengeluaran }
            .reduce(0) { $0 + $1.amount }
    }
    
    public var groupedTransactions: [(key: Date, value: [CashFlowModel])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: transactions) { item in
            calendar.startOfDay(for: item.date)
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
    
    @MainActor
    public func loadTransactions() async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.allTransactions = try await service.getCashFlowTransactions()
            applyFilters()
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }

    public func applyFilters() {
        let calendar = Calendar.current
        let normalizedStartDate = calendar.startOfDay(for: useCustomDateRange ? startDate : monthStartDate(for: selectedDate))
        let normalizedEndDate = calendar.startOfDay(for: useCustomDateRange ? endDate : monthEndDate(for: selectedDate))
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let minAmount = Double(minAmountFilter.replacingOccurrences(of: ",", with: "")) ?? 0
        let maxAmount = Double(maxAmountFilter.replacingOccurrences(of: ",", with: "")) ?? .greatestFiniteMagnitude
        
        transactions = allTransactions.filter { transaction in
            let transactionDay = calendar.startOfDay(for: transaction.date)
            guard transactionDay >= normalizedStartDate, transactionDay <= normalizedEndDate else {
                return false
            }
            
            guard transaction.amount >= minAmount, transaction.amount <= maxAmount else {
                return false
            }
            
            if let status = selectedPaymentStatus, transaction.paymentStatus != status.title {
                return false
            }
            
            if let selectedCategory {
                switch selectedCategory {
                case .all:
                    break
                case .incomeStatus(let status):
                    guard transaction.type == .pemasukan, transaction.paymentStatus == status.title else {
                        return false
                    }
                case .expenseItem(let category):
                    guard transaction.type == .pengeluaran,
                          transaction.expense?.category?.id == category.id || transaction.expense?.category?.name == category.name else {
                        return false
                    }
                }
            }
            
            guard !query.isEmpty else {
                return true
            }
            
            let searchableText = [
                transaction.counterpartyName,
                transaction.description,
                transaction.paymentStatus,
                transaction.income?.identifier,
                transaction.expense?.category?.name
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
