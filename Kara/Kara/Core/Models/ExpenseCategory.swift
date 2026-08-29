//
//  ExpenseCategory.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 24/08/26.
//

import Foundation

public struct ExpenseCategory: Identifiable, Codable, Hashable {
    public var id: UUID
    public var name: String
    
    public init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

