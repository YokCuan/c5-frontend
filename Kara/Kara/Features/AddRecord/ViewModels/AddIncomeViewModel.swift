import SwiftUI
import Combine

@MainActor
public final class AddIncomeViewModel: ObservableObject {
    @Published public var incomeDescription = ""
    @Published public var amount: Int = 0
    @Published public var buyerName = ""
    @Published public var transactionDate = Date()
    @Published public var paymentStatus: PaymentStatus = .paid
    
    @Published public var isLoading = false
    @Published public var isSaved = false
    @Published public var errorMessage: String?
    
    private let service = FirebaseService.shared
    
    public init() {}
    
    public func save() async {
        guard amount > 0 else {
            self.errorMessage = "Jumlah pemasukan harus lebih dari 0."
            return
        }
        
        guard !incomeDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.errorMessage = "Deskripsi tidak boleh kosong."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let income = CashFlowModel(
                id: UUID(),
                amount: Double(amount),
                type: .pemasukan,
                description: incomeDescription,
                counterpartyName: buyerName,
                paymentStatus: paymentStatus.title,
                date: transactionDate,
                income: nil,
                expense: nil
            )
            
            try await service.saveCashFlowTransaction(income)
            isSaved = true
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
