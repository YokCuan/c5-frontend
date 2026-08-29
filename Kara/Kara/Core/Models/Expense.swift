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
}
