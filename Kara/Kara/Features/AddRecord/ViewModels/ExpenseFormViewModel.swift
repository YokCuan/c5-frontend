import Foundation
import Combine

public struct ExpenseItemInput: Identifiable {
    public let id: UUID
    public var name: String
    
    public init(id: UUID = UUID(), name: String = "") {
        self.id = id
        self.name = name
    }
}

public enum ExpenseFormMode: Equatable {
    case add
    case edit(expenseId: UUID)
}

@MainActor
public final class ExpenseFormViewModel: ObservableObject {
    public let mode: ExpenseFormMode
    
    @Published public var transactionDate: Date = Date()
    @Published public var supplierName: String = ""
    @Published public var supplierPhone: String = ""
    @Published public var items: [ExpenseItemInput] = [ExpenseItemInput()]
    @Published public var paidAmountText: String = ""
    @Published public var selectedExpenseCategoryId: UUID? = nil
    
    @Published public var isLoading: Bool = false
    @Published public var isSaving: Bool = false
    @Published public var isSaved: Bool = false
    @Published public var errorMessage: String? = nil
    
    public init(mode: ExpenseFormMode) {
        self.mode = mode
    }
    
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
    
    public var isSupplierNameValid: Bool {
        return !supplierName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    public var isFormValid: Bool {
        areItemsValid && isPaidAmountValid && selectedExpenseCategoryId != nil && isSupplierNameValid
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
    
    public func loadDataIfNeeded(shopId: UUID) async {
        if case .edit(let expenseId) = mode {
            isLoading = true
            errorMessage = nil
            do {
                let fetchedExpense = try await APIService.shared.fetchExpenseDetail(
                    id: expenseId,
                    shopId: shopId
                )
                self.transactionDate = fetchedExpense.purchasedAt
                let mappedItems = fetchedExpense.items?.map { ExpenseItemInput(name: $0.name ?? "") } ?? []
                self.items = mappedItems.isEmpty ? [ExpenseItemInput()] : mappedItems
                self.paidAmountText = String(format: "%.0f", fetchedExpense.paidAmount)
                self.selectedExpenseCategoryId = fetchedExpense.expenseCategoryId
                self.supplierName = fetchedExpense.supplierName ?? ""
                self.supplierPhone = fetchedExpense.supplierPhone ?? ""
                self.isLoading = false
            } catch {
                self.errorMessage = "Gagal memuat detail pengeluaran: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    public func save(shopId: UUID, userId: UUID) async {
        guard isFormValid else {
            self.errorMessage = "Mohon lengkapi semua field yang wajib diisi."
            return
        }
        
        isSaving = true
        errorMessage = nil
        
        let itemsArray: [[String: String]] = items.compactMap { item in
            let trimmedName = item.name.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmedName.isEmpty ? nil : ["name": trimmedName]
        }
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let formattedDate = formatter.string(from: transactionDate)
        
        var rawBody: [String: Any] = [
            "expenseCategoryId": selectedExpenseCategoryId!.uuidString,
            "supplierName": supplierName.trimmingCharacters(in: .whitespacesAndNewlines),
            "supplierPhone": supplierPhone.trimmingCharacters(in: .whitespacesAndNewlines),
            "paidAmount": parsedPaidAmount!,
            "purchasedAt": formattedDate,
            "updatedBy": userId.uuidString,
            "items": itemsArray
        ]
        
        do {
            switch mode {
            case .add:
                rawBody["shopId"] = shopId.uuidString
                rawBody["createdBy"] = userId.uuidString
                try await APIService.shared.createExpense(body: rawBody)
            case .edit(let expenseId):
                try await APIService.shared.patchExpense(
                    id: expenseId,
                    shopId: shopId,
                    body: rawBody
                )
            }
            self.isSaved = true
            self.isSaving = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isSaving = false
        }
    }
}
