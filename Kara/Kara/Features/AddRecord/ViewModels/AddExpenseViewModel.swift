import Foundation
import Combine

@MainActor
public final class AddExpenseViewModel: ObservableObject {
    @Published public var transactionDate: Date = Date()
    @Published public var supplierName: String = ""
    @Published public var supplierPhone: String = ""
    @Published public var items: [ExpenseItemInput] = [ExpenseItemInput()]
    @Published public var paidAmountText: String = ""
    @Published public var selectedExpenseCategoryId: UUID? = nil
    
    @Published public var isLoading: Bool = false
    @Published public var isSaved: Bool = false
    @Published public var errorMessage: String? = nil
    
    public init() {}
    
    public var areItemsValid: Bool {
        guard !items.isEmpty else { return false }
        return items.allSatisfy {
            !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    public var isPaidAmountValid: Bool {
        guard let amount = parsedPaidAmount else { return false }
        return amount > 0
    }
    
    public var parsedPaidAmount: Double? {
        let cleanedText = paidAmountText.replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: ".", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return Double(cleanedText)
    }
    
    public func addItem() {
        items.append(ExpenseItemInput())
    }
    
    public func removeItem(id: UUID) {
        if items.count > 1 {
            items.removeAll { $0.id == id }
        }
    }
    
    public func createExpense(shopId: UUID, userId: UUID) async {
        guard areItemsValid else {
            self.errorMessage = "Nama barang tidak boleh kosong."
            return
        }
        
        guard let paidAmount = parsedPaidAmount, isPaidAmountValid else {
            self.errorMessage = "Jumlah yang dibayar harus lebih dari 0."
            return
        }
        
        guard let categoryId = selectedExpenseCategoryId else {
            self.errorMessage = "Kategori pengeluaran wajib dipilih."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let itemsArray: [[String: String]] = items.compactMap { item in
            let trimmedName = item.name.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmedName.isEmpty ? nil : ["name": trimmedName]
        }
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let formattedDate = formatter.string(from: transactionDate)
        
        let rawBody: [String: Any] = [
            "shopId": shopId.uuidString,
            "expenseCategoryId": categoryId.uuidString,
            "supplierName": supplierName.trimmingCharacters(in: .whitespacesAndNewlines),
            "supplierPhone": supplierPhone.trimmingCharacters(in: .whitespacesAndNewlines),
            "paidAmount": paidAmount,
            "purchasedAt": formattedDate,
            "createdBy": userId.uuidString,
            "updatedBy": userId.uuidString,
            "items": itemsArray
        ]
        
        do {
            try await APIService.shared.createExpense(body: rawBody)
            self.isSaved = true
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
}


