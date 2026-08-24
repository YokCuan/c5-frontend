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

// Dummy Data
public extension ExpenseCategory {
    static let defaults: [ExpenseCategory] = [
        ExpenseCategory(name: "Bahan Baku"),
        ExpenseCategory(name: "Kemasan"),
        ExpenseCategory(name: "Listrik, Gas, Air, Sewa"),
        ExpenseCategory(name: "Pengiriman"),
        ExpenseCategory(name: "Gaji Pekerja"),
        ExpenseCategory(name: "Diambil untuk Pribadi"),
        ExpenseCategory(name: "Lainnya")
    ]
}
