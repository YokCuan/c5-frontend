//
//  Expense.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 24/08/26.
//

import Foundation

public struct Expense: Identifiable, Codable {
    public var id: UUID
    public var shopId: UUID
    public var expenseCategoryId: UUID
    
    public var supplierName: String?
    public var supplierPhone: String?
    public var paidAmount: Double
    public var purchasedAt: Date
    
   
    public var createdAt: Date
    public var createdBy: UUID
    public var updatedAt: Date
    public var updatedBy: UUID
    
    public var items: [ExpenseItem]?
    public var category: ExpenseCategory?
    
    public init(
        id: UUID = UUID(),
        shopId: UUID,
        expenseCategoryId: UUID,
        supplierName: String? = nil,
        supplierPhone: String? = nil,
        paidAmount: Double,
        purchasedAt: Date = Date(),
        createdAt: Date = Date(),
        createdBy: UUID,
        updatedAt: Date = Date(),
        updatedBy: UUID,
        items: [ExpenseItem]? = nil,
        category: ExpenseCategory? = nil
    ) {
        self.id = id
        self.shopId = shopId
        self.expenseCategoryId = expenseCategoryId
        self.supplierName = supplierName
        self.supplierPhone = supplierPhone
        self.paidAmount = paidAmount
        self.purchasedAt = purchasedAt
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.updatedAt = updatedAt
        self.updatedBy = updatedBy
        self.items = items
        self.category = category
    }
}
