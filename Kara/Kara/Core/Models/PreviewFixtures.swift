//
//  PreviewFixtures.swift
//  Kara
//
//  Created by OpenAI Codex on 29/08/26.
//

import Foundation

enum PreviewFixtures {
    private static func dayOffset(_ value: Int, hour: Int = 10, minute: Int = 0) -> Date {
        let calendar = Calendar.current
        let base = calendar.startOfDay(for: Date())
        let date = calendar.date(byAdding: .day, value: value, to: base) ?? Date()
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: date) ?? date
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
        itemName: String
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
            items: [
                SalesNoteItem(
                    id: UUID(),
                    salesNoteId: id,
                    name: itemName,
                    quantity: 1,
                    unitPrice: totalAmount,
                    subtotal: totalAmount
                )
            ]
        )
    }

    static let paidSalesNote = makeSalesNote(
        idString: "#8612",
        customerName: "Bu Ria",
        customerPhone: "08123456789",
        totalAmount: 96_000,
        paidAmount: 96_000,
        status: .paid,
        dueAt: nil,
        soldAt: dayOffset(0, hour: 18),
        itemName: "Keripik Tempe 100 g"
    )

    static let dpSalesNote = makeSalesNote(
        idString: "#8614",
        customerName: "Pak Andi",
        customerPhone: "081298765432",
        totalAmount: 75_000,
        paidAmount: 25_000,
        status: .dp,
        dueAt: dayOffset(4, hour: 17),
        soldAt: dayOffset(-1, hour: 11, minute: 20),
        itemName: "Keripik Tempe 250 g"
    )

    static let notPaidSalesNote = makeSalesNote(
        idString: "#8622",
        customerName: "Toko Maju Jaya",
        customerPhone: "085811223344",
        totalAmount: 120_000,
        paidAmount: 0,
        status: .notPaid,
        dueAt: dayOffset(2, hour: 15),
        soldAt: dayOffset(-2, hour: 15, minute: 40),
        itemName: "Paket Reseller Keripik"
    )
}
