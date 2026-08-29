//
//  AppMockData.swift
//  Kara
//
//  Created by OpenAI Codex on 26/08/26.
//

import Foundation

public enum AppMockData {
    private enum IDs {
        static let owner = UUID(uuidString: "D8E82A1A-615C-4FE3-8AB0-DF7A2B24A417")!
        static let shop = UUID(uuidString: "724E0DB3-6BEC-419F-A03F-81790B55358A")!
    }

    public static let currentUser = User(
        id: IDs.owner,
        name: "Ria Tan",
        phone: "08578987666",
        password: "password123"
    )

    public static let primaryShop = Shop(
        id: IDs.shop,
        ownerId: IDs.owner,
        name: "Pempek Palembang 99",
        description: "#1 Pempek se-Academy",
        address: "Thamrin",
        phone: "08578987666"
    )

    public static let shops: [Shop] = [
        primaryShop
    ]
}
