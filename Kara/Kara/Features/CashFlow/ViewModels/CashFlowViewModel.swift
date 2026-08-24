import SwiftUI
import Combine

@MainActor
public class CashFlowViewModel: ObservableObject {
    @Published public var transactions: [CashFlowModel] = []
    @Published public var totalIncome: Int = 0
    @Published public var totalExpense: Int = 0
    
    @Published public var currentDate: Date = Date() {
            didSet {
                updateDateBounds()
            }
        }
    
    @Published public var startDate: Date = Date()
    @Published public var endDate: Date = Date()
    
    @Published public var searchText: String = "" // Kept once here
    @Published public var selectedPaymentStatus: PaymentStatus? = nil
    
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    
    private let service = FirebaseService.shared
    
    public init() {
            updateDateBounds()
        }
    
    // MARK: - Month Navigation Best Practices
        
        public var selectedMonthYearString: String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "id_ID")
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: currentDate)
        }
        
        public func previousMonth() {
            if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) {
                currentDate = newDate
                Task { await loadTransactions() }
            }
        }
        
        public func nextMonth() {
            if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) {
                currentDate = newDate
                Task { await loadTransactions() }
            }
        }
        
        // Automatically sets startDate to 1st of month (00:00) and endDate to last day of month (23:59)
        private func updateDateBounds() {
            let calendar = Calendar.current
            
            if let interval = calendar.dateInterval(of: .month, for: currentDate) {
                self.startDate = interval.start
                self.endDate = interval.end.addingTimeInterval(-1)
            }
        }
        
        // MARK: - Data Fetching
    
    public func loadTransactions() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Fetch from Firebase Service
            let fetched = try await service.getCashFlowTransactions()
            
            // Filter by date range
            let filtered = fetched.filter { $0.date >= startDate && $0.date <= endDate }
            
            self.transactions = filtered.sorted { $0.date > $1.date }
            
            // Calculate totals
            self.totalIncome = filtered.filter { $0.type == .pemasukan }.reduce(0) { $0 + $1.amount }
            self.totalExpense = filtered.filter { $0.type == .pengeluaran }.reduce(0) { $0 + $1.amount }
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // Group transactions by date for UI display
    public var groupedTransactions: [(key: Date, value: [CashFlowModel])] {
        let grouped = Dictionary(grouping: transactions) { transaction -> Date in
            let components = Calendar.current.dateComponents([.year, .month, .day], from: transaction.date)
            return Calendar.current.date(from: components) ?? transaction.date
        }
        return grouped.sorted { $0.key > $1.key }
    }
}
