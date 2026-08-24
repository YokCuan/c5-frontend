//
//  ExpenseItem.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 24/08/26.
//

import Foundation

public struct ExpenseItem: Identifiable, Codable, Hashable {
    public var id: UUID
    public var expenseId: UUID
    public var name: String?     
    
    public init(
        id: UUID = UUID(),
        expenseId: UUID,
        name: String? = nil
    ) {
        self.id = id
        self.expenseId = expenseId
        self.name = name
    }
}
