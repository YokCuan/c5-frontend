//
//  Shop.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 24/08/26.
//

import Foundation

public struct Shop: Identifiable, Codable {
    public var id: UUID
    public var ownerId: UUID
    public var name: String
    public var description: String?
    public var address: String?
    public var phone: String?
    
    public init(
        id: UUID = UUID(),
        ownerId: UUID,
        name: String,
        description: String,
        address: String? = nil,
        phone: String? = nil
    ) {
        self.id = id
        self.ownerId = ownerId
        self.name = name
        self.description = description
        self.address = address
        self.phone = phone
    }
}
