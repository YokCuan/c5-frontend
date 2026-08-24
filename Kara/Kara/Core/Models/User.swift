//
//  User.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 24/08/26.
//

import Foundation

public struct User: Identifiable, Codable {
    public var id: UUID
    public var name: String
    public var phone: String
    public var password: String
    
    public init(
        id: UUID = UUID(),
        name: String,
        phone: String,
        password: String
    ) {
        self.id = id
        self.name = name
        self.phone = phone
        self.password = password
    }
}
