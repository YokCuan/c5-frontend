import Foundation
import Combine

public class CashFlowViewModel: ObservableObject {
    @Published public var transactions: [CashFlowModel] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    
    @Published public var selectedDate: Date = Date()
    @Published public var startDate: Date = Date()
    @Published public var endDate: Date = Date()
    
    private let service = FirebaseService.shared
    
    public init() {}
    
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
            Task { await loadTransactions() }
        }
    }
    
    public func previousMonth() {
        if let prev = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) {
            selectedDate = prev
            Task { await loadTransactions() }
        }
    }
    
    @MainActor
    public func loadTransactions() async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.transactions = try await service.getCashFlowTransactions()
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
}
