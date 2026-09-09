//
//  AppMockData.swift
//  Kara
//
//  Created by OpenAI Codex on 26/08/26.
//

import Foundation

public enum AppMockData {
    private enum IDs {
        static let owner = UUID(uuidString: "152CA26B-6AC4-425B-84F0-7732064E85B2")!
        static let shop = UUID(uuidString: "BE24B313-860E-49F3-B7DD-0CFA08F0E388")!
    }

    public static let currentUser = User(
        id: IDs.owner,
        name: "Ria Tan",
        phone: "+628578987666",
        password: "password123"
    )

    public static let primaryShop = Shop(
        id: IDs.shop,
        ownerId: IDs.owner,
        name: "Keripik Tempe KARAOKE",
        description: "#1 Keripik Tempe se-Academy",
        address: "Thamrin",
        phone: "08578987666"
    )

    public static let shops: [Shop] = [
        primaryShop
    ]
}
