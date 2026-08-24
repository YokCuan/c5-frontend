//
//  SalesNoteItem.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 24/08/26.
//

import Foundation

public struct SalesNoteItem: Identifiable, Codable {
    public var id: UUID
    public var salesNoteId: UUID
    public var name: String
    public var quantity: Int
    public var unitPrice: Double
    public var subtotal: Double
}
