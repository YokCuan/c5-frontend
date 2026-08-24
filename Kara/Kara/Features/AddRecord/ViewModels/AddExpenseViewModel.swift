import SwiftUI
import Combine

@MainActor
public final class AddExpenseViewModel: ObservableObject {
    @Published public var expenseDescription = ""
    @Published public var amount: Int = 0
    @Published public var items: [String] = []
    @Published public var newItemText = ""
    @Published public var category = ""
    @Published public var storeName = ""
    @Published public var storeContact = ""
    @Published public var transactionDate = Date()
    
    @Published public var isLoading = false
    @Published public var isSaved = false
    @Published public var errorMessage: String?
    
    private let service = FirebaseService.shared
    
    public init() {}
    
    public func addItem() {
        let trimmed = newItemText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            items.append(trimmed)
            newItemText = ""
        }
    }
    
    public func removeItem(at index: Int) {
        items.remove(at: index)
    }
    
    public func save() async {
        // Business Validation inside ViewModel
        guard amount > 0 else {
            self.errorMessage = "Jumlah pengeluaran harus lebih dari 0."
            return
        }
        
        let fullDescription = expenseDescription + (items.isEmpty ? "" : " - " + items.joined(separator: ", "))
        guard !fullDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.errorMessage = "Deskripsi tidak boleh kosong."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Build Model
            let expense = CashFlowModel(
                amount: amount,
                type: .pengeluaran,
                description: fullDescription,
                date: transactionDate,
                counterpartyName: storeName,
                paymentStatus: PaymentStatus.paid.title
            )
            
            // Save to Firebase
            try await service.saveCashFlowTransaction(expense)
            
            isSaved = true
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
