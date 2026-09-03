//
//  AddSalesNoteViewModel.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 29/08/26.
//

import Foundation
import Combine

public struct SalesNoteItemInput: Identifiable {
    public let id: UUID
    public var name: String
    public var quantityText: String
    public var unitPriceText: String

    public init(id: UUID = UUID(), name: String = "", quantityText: String = "", unitPriceText: String = "") {
        self.id = id
        self.name = name
        self.quantityText = quantityText
        self.unitPriceText = unitPriceText
    }
}

@MainActor
public final class AddSalesNoteViewModel: ObservableObject {
    @Published public var customerName: String = ""
    @Published public var customerPhone: String = ""
    @Published public var soldAt: Date = Date()
    @Published public var dueAt: Date = Date()
    @Published public var hasDueDate: Bool = false
    @Published public var isBelumLunas: Bool = false
    @Published public var items: [SalesNoteItemInput] = [SalesNoteItemInput()]
    @Published public var paidAmountText: String = "0"
    
    @Published public var isLoading: Bool = false
    @Published public var isSaved: Bool = false
    @Published public var errorMessage: String? = nil
    
    public init() {}
    
    public var calculatedTotal: Double {
        items.reduce(0) { total, item in
            let qty = Double(item.quantityText.replacingOccurrences(of: ",", with: "")) ?? 0
            let price = Double(item.unitPriceText.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")) ?? 0
            return total + (qty * price)
        }
    }
    
    public var areItemsValid: Bool {
        guard !items.isEmpty else { return false }
        return items.allSatisfy { item in
            let isNameValid = !item.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            let qty = Double(item.quantityText.replacingOccurrences(of: ",", with: "")) ?? 0
            let price = Double(item.unitPriceText.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")) ?? 0
            return isNameValid && qty > 0 && price >= 0
        }
    }
    
    public var isPaidAmountValid: Bool {
        if !isBelumLunas { return true }
        guard let amount = parsedPaidAmount else { return false }
        return amount >= 0
    }
    
    public var remainingAmount: Double {
        if !isBelumLunas { return 0 }
        let cleanPaid = parsedPaidAmount ?? 0
        return max(0, calculatedTotal - cleanPaid)
    }
    
    public var isCustomerNameValid: Bool {
        !customerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    public var isPaidAmountExceedingTotal: Bool {
        if !isBelumLunas { return false }
        let paid = parsedPaidAmount ?? 0
        return calculatedTotal > 0 && paid > calculatedTotal
    }

    public var isFormValid: Bool {
        isCustomerNameValid
        && areItemsValid
        && isPaidAmountValid
        && !isPaidAmountExceedingTotal
    }
    
    public var parsedPaidAmount: Double? {
        let cleanedText = paidAmountText.replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: ".", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanedText.isEmpty { return 0 }
        return Double(cleanedText)
    }
    
    public func addItem() {
        items.append(SalesNoteItemInput())
    }
    
    public func removeItem(id: UUID) {
        if items.count > 1 {
            items.removeAll { $0.id == id }
        }
    }
    
    public func createSalesNote(shopId: UUID, userId: UUID) async {
        guard isCustomerNameValid else {
            self.errorMessage = "Nama pembeli tidak boleh kosong."
            return
        }
        
        guard areItemsValid else {
            self.errorMessage = "Pastikan nama barang, jumlah (qty), dan harga satuan terisi dengan benar."
            return
        }
        
        guard !isPaidAmountExceedingTotal else {
            self.errorMessage = "Nominal melebihi total harga barang."
            return
        }
        
        let finalPaidAmount: Double
        if isBelumLunas {
            guard let paidAmount = parsedPaidAmount, isPaidAmountValid else {
                self.errorMessage = "Jumlah yang dibayar tidak valid."
                return
            }
            finalPaidAmount = paidAmount
        } else {
            finalPaidAmount = calculatedTotal
        }
        
        isLoading = true
        errorMessage = nil
        
        let itemsArray: [[String: Any]] = items.map { item in
            let qty = Double(item.quantityText.replacingOccurrences(of: ",", with: "")) ?? 0
            let price = Double(item.unitPriceText.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")) ?? 0
            return [
                "name": item.name.trimmingCharacters(in: .whitespacesAndNewlines),
                "quantity": qty,
                "unitPrice": price
            ]
        }
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let formattedSoldAt = formatter.string(from: soldAt)
        let formattedDueAt = hasDueDate ? formatter.string(from: dueAt) : nil
        
        var rawBody: [String: Any] = [
            "shopId": shopId.uuidString,
            "customerName": customerName.trimmingCharacters(in: .whitespacesAndNewlines),
            "customerPhone": customerPhone.trimmingCharacters(in: .whitespacesAndNewlines),
            "paidAmount": finalPaidAmount,
            "noteFileLink": NSNull(),
            "soldAt": formattedSoldAt,
            "createdBy": userId.uuidString,
            "updatedBy": userId.uuidString,
            "items": itemsArray
        ]
        
        if let formattedDueAt {
            rawBody["dueAt"] = formattedDueAt
        } else {
            rawBody["dueAt"] = NSNull()
        }
        
        do {
            try await APIService.shared.createSalesNote(body: rawBody)
            self.isSaved = true
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
}
