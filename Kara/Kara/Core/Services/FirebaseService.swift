import Foundation

/// A simple service to handle all Firebase/Firestore operations.
/// In standard MVVM, ViewModels talk directly to this service.
public class FirebaseService {
    public static let shared = FirebaseService()
    
    private var cashFlowTransactionStorage = AppMockData.cashFlowTransactions
    
    private init() {}
    
    // MARK: - CashFlow Operations
    
    public func getCashFlowTransactions() async throws -> [CashFlowModel] {
        // TODO: Replace with actual Firestore fetch
        // let snapshot = try await db.collection("cashflows").getDocuments()
        // return snapshot.documents.compactMap { try? $0.data(as: CashFlowModel.self) }
        
        // Mock data for now so the app runs smoothly
        return cashFlowTransactionStorage.sorted { $0.date > $1.date }
    }
    
    public func saveCashFlowTransaction(_ transaction: CashFlowModel) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        cashFlowTransactionStorage.append(transaction)
        print("Saved transaction to Firebase: \(transaction.description)")
    }
}
