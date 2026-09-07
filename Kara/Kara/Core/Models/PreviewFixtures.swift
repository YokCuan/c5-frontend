//
//  PreviewFixtures.swift
//  Kara
//
//  Created by OpenAI Codex on 29/08/26.
//

import Foundation

enum PreviewFixtures {
    private static func parseDate(_ string: String?) -> Date? {
        guard let string = string else { return nil }
        return ISO8601DateFormatter().date(from: string)
    }

    private static func makeSalesNote(
        idString: String,
        customerName: String,
        customerPhone: String?,
        totalAmount: Double,
        paidAmount: Double,
        status: PaymentStatus,
        dueAt: Date?,
        soldAt: Date,
        items: [SalesNoteItem] = [],
        payments: [SalesNotePayment] = []
    ) -> SalesNote {
        let id = UUID(uuidString: idString) ?? UUID()
        return SalesNote(
            id: id,
            shopId: AppMockData.primaryShop.id,
            identifier: idString,
            customerName: customerName,
            customerPhone: customerPhone,
            totalAmount: totalAmount,
            paidAmount: paidAmount,
            status: status,
            noteFileLink: nil,
            dueAt: dueAt,
            soldAt: soldAt,
            items: items,
            payments: payments
        )
    }

    // 1. Paid Sales Note
    static let paidSalesNote = makeSalesNote(
        idString: "4E6FA395-A11E-4386-81BC-4CE085AED0E7",
        customerName: "John Doe",
        customerPhone: "+1234567890",
        totalAmount: 120000,
        paidAmount: 120000,
        status: .paid,
        dueAt: nil,
        soldAt: parseDate("2026-09-01T15:12:55Z") ?? Date(),
        items: [
            SalesNoteItem(
                id: UUID(uuidString: "5B025B98-3101-4A12-834A-078FEECC6860")!,
                salesNoteId: UUID(uuidString: "4E6FA395-A11E-4386-81BC-4CE085AED0E7")!,
                name: "Product A",
                quantity: 2,
                unitPrice: 40000,
                subtotal: 80000
            ),
            SalesNoteItem(
                id: UUID(uuidString: "C25D122D-EE62-4A8B-B27B-8A8E64F44662")!,
                salesNoteId: UUID(uuidString: "4E6FA395-A11E-4386-81BC-4CE085AED0E7")!,
                name: "Product B",
                quantity: 1,
                unitPrice: 40000,
                subtotal: 40000
            )
        ],
        payments: [
            SalesNotePayment(
                id: UUID(uuidString: "73FDB853-7404-4073-8DA0-168371D677E5")!,
                salesNoteId: UUID(uuidString: "4E6FA395-A11E-4386-81BC-4CE085AED0E7")!,
                paymentAttempt: 1,
                paidAmount: 120000,
                paidAt: parseDate("2026-09-01T00:00:00Z") ?? Date()
            )
        ]
    )

    // 2. DP / Partially Paid Sales Note
    static let dpSalesNote = makeSalesNote(
        idString: "0A2CEEAB-7EA8-4810-83B5-6A406C1A32AF",
        customerName: "John Doe",
        customerPhone: "+1234567890",
        totalAmount: 120000,
        paidAmount: 100000,
        status: .dp,
        dueAt: nil,
        soldAt: parseDate("2026-08-27T00:00:00Z") ?? Date(),
        items: [
            SalesNoteItem(
                id: UUID(uuidString: "71C946C5-28DB-41A9-A17C-AA3B5D5F529D")!,
                salesNoteId: UUID(uuidString: "0A2CEEAB-7EA8-4810-83B5-6A406C1A32AF")!,
                name: "Product A",
                quantity: 2,
                unitPrice: 40000,
                subtotal: 80000
            ),
            SalesNoteItem(
                id: UUID(uuidString: "DFB888D7-2BC0-4627-8F9C-CCA97A2FBC1D")!,
                salesNoteId: UUID(uuidString: "0A2CEEAB-7EA8-4810-83B5-6A406C1A32AF")!,
                name: "Product B",
                quantity: 1,
                unitPrice: 40000,
                subtotal: 40000
            )
        ],
        payments: [
            SalesNotePayment(
                id: UUID(uuidString: "73FDB853-7404-4073-8DA0-168371D677E5")!,
                salesNoteId: UUID(uuidString: "0A2CEEAB-7EA8-4810-83B5-6A406C1A32AF")!,
                paymentAttempt: 1,
                paidAmount: 100000,
                paidAt: parseDate("2026-09-01T00:00:00Z") ?? Date()
            )
        ]
    )

    // 3. Not Paid Sales Note
    static let notPaidSalesNote = makeSalesNote(
        idString: "D3773A81-32C1-4915-8BC4-68F85E5E3A9B",
        customerName: "John Doe",
        customerPhone: "+1234567890",
        totalAmount: 150000,
        paidAmount: 0,
        status: .notPaid,
        dueAt: parseDate("2026-09-30T00:00:00Z"),
        soldAt: parseDate("2026-08-27T00:00:00Z") ?? Date(),
        items: [
            SalesNoteItem(
                id: UUID(uuidString: "71C946C5-28DB-41A9-A17C-AA3B5D5F529D")!,
                salesNoteId: UUID(uuidString: "0A2CEEAB-7EA8-4810-83B5-6A406C1A32AF")!,
                name: "Product A",
                quantity: 2,
                unitPrice: 40000,
                subtotal: 80000
            ),
            SalesNoteItem(
                id: UUID(uuidString: "DFB888D7-2BC0-4627-8F9C-CCA97A2FBC1D")!,
                salesNoteId: UUID(uuidString: "0A2CEEAB-7EA8-4810-83B5-6A406C1A32AF")!,
                name: "Product B",
                quantity: 1,
                unitPrice: 40000,
                subtotal: 40000
            )
        ],
        payments: []
    )

    static let allSalesNotes: [SalesNote] = [
        paidSalesNote, dpSalesNote, notPaidSalesNote
    ]
}
