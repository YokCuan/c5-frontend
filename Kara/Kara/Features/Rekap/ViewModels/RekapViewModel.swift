import SwiftUI
import Combine

@MainActor
public class RekapViewModel: ObservableObject {
    @Published public var totalIncome: Double = 0
    @Published public var totalExpense: Double = 0
    
    public var netBalance: Double {
        totalIncome - totalExpense
    }
    
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    
    private let service = FirebaseService.shared
    
    public init() {}
    
    public func loadRekap() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetched = try await service.getCashFlowTransactions()
            
            // Calculate totals
            self.totalIncome = fetched.filter { $0.type == .pemasukan }.reduce(0) { $0 + $1.amount }
            self.totalExpense = fetched.filter { $0.type == .pengeluaran }.reduce(0) { $0 + $1.amount }
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
