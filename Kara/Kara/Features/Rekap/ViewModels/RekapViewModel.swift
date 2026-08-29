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
    
    private let service = APIService.shared
    
    public init() {}
    
    public func loadRekap(shopId: UUID) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetched = try await service.fetchCashFlows(shopId: shopId)
            
            self.totalIncome = fetched.filter { $0.type == .salesNote }.reduce(0) { $0 + $1.amount }
            self.totalExpense = fetched.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
