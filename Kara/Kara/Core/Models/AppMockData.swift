//
//  AppMockData.swift
//  Kara
//
//  Created by OpenAI Codex on 26/08/26.
//

import Foundation

enum AppMockData {
    private enum IDs {
        static let owner = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
        static let shop = UUID(uuidString: "22222222-2222-2222-2222-222222222222")!

        static let rawMaterialCategory = UUID(uuidString: "33333333-3333-3333-3333-333333333333")!
        static let packagingCategory = UUID(uuidString: "44444444-4444-4444-4444-444444444444")!
        static let utilitiesCategory = UUID(uuidString: "55555555-5555-5555-5555-555555555555")!
        static let shippingCategory = UUID(uuidString: "66666666-6666-6666-6666-666666666666")!
        static let salaryCategory = UUID(uuidString: "77777777-7777-7777-7777-777777777777")!
        static let personalCategory = UUID(uuidString: "88888888-8888-8888-8888-888888888888")!
        static let otherCategory = UUID(uuidString: "99999999-9999-9999-9999-999999999999")!
    }

    private static func dayOffset(_ value: Int, hour: Int = 10, minute: Int = 0) -> Date {
        let calendar = Calendar.current
        let base = calendar.startOfDay(for: Date())
        let date = calendar.date(byAdding: .day, value: value, to: base) ?? Date()
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: date) ?? date
    }

    // MARK: - User & Shop
    static let currentUser = User(
        id: IDs.owner,
        name: "Jessica Winardy",
        phone: "081234567890",
        password: "password123"
    )

    static let primaryShop = Shop(
        id: IDs.shop,
        ownerId: IDs.owner,
        name: "Kara Snack House",
        description: "Produksi keripik tempe dan sagu",
        address: "Jl. Melati No. 12, Bandung",
        phone: "081234567890"
    )

    static let shops: [Shop] = [
        primaryShop,
        Shop(
            ownerId: IDs.owner,
            name: "Kara Coffee Corner",
            description: "Kedai kopi dan camilan"
        )
    ]

    // MARK: - Expense Categories
    static let expenseCategories: [ExpenseCategory] = [
        ExpenseCategory(id: IDs.rawMaterialCategory, name: "Bahan Baku"),
        ExpenseCategory(id: IDs.packagingCategory, name: "Kemasan"),
        ExpenseCategory(id: IDs.utilitiesCategory, name: "Listrik, Gas, Air, Sewa"),
        ExpenseCategory(id: IDs.shippingCategory, name: "Pengiriman"),
        ExpenseCategory(id: IDs.salaryCategory, name: "Gaji Pekerja"),
        ExpenseCategory(id: IDs.personalCategory, name: "Diambil untuk Pribadi"),
        ExpenseCategory(id: IDs.otherCategory, name: "Lainnya")
    ]

    // MARK: - Expenses (Banyak Entitas)
    static let expenses: [Expense] = [
        Expense(
            id: UUID(),
            shopId: primaryShop.id,
            expenseCategoryId: IDs.rawMaterialCategory,
            supplierName: "Toko Sumber Makmur",
            supplierPhone: "081234500111",
            paidAmount: 350_000,
            purchasedAt: dayOffset(-1, hour: 9, minute: 30),
            createdBy: IDs.owner,
            updatedBy: IDs.owner,
            items: [
                ExpenseItem(id: UUID(), expenseId: UUID(), name: "Tepung terigu 25 kg"),
                ExpenseItem(id: UUID(), expenseId: UUID(), name: "Minyak goreng 5 liter")
            ],
            category: expenseCategories[0]
        ),
        Expense(
            id: UUID(),
            shopId: primaryShop.id,
            expenseCategoryId: IDs.packagingCategory,
            supplierName: "CV Bungkus Jaya",
            supplierPhone: "081234500222",
            paidAmount: 125_000,
            purchasedAt: dayOffset(-3, hour: 14, minute: 15),
            createdBy: IDs.owner,
            updatedBy: IDs.owner,
            items: [
                ExpenseItem(id: UUID(), expenseId: UUID(), name: "Plastik kemasan 1 pack"),
                ExpenseItem(id: UUID(), expenseId: UUID(), name: "Stiker label brand")
            ],
            category: expenseCategories[1]
        ),
        Expense(
            id: UUID(),
            shopId: primaryShop.id,
            expenseCategoryId: IDs.rawMaterialCategory,
            supplierName: "Pak Haji Kedelai",
            supplierPhone: "081399887766",
            paidAmount: 240_000,
            purchasedAt: dayOffset(-5, hour: 8, minute: 15),
            createdBy: IDs.owner,
            updatedBy: IDs.owner,
            items: [
                ExpenseItem(id: UUID(), expenseId: UUID(), name: "Kedelai impor 20 kg"),
                ExpenseItem(id: UUID(), expenseId: UUID(), name: "Ragi tempe 5 pack")
            ],
            category: expenseCategories[0]
        ),
        Expense(
            id: UUID(),
            shopId: primaryShop.id,
            expenseCategoryId: IDs.utilitiesCategory,
            supplierName: "PLN & PDAM",
            supplierPhone: nil,
            paidAmount: 275_000,
            purchasedAt: dayOffset(-8, hour: 10, minute: 0),
            createdBy: IDs.owner,
            updatedBy: IDs.owner,
            items: [
                ExpenseItem(id: UUID(), expenseId: UUID(), name: "Token listrik produksi"),
                ExpenseItem(id: UUID(), expenseId: UUID(), name: "Air PDAM bulanan")
            ],
            category: expenseCategories[2]
        ),
        Expense(
            id: UUID(),
            shopId: primaryShop.id,
            expenseCategoryId: IDs.shippingCategory,
            supplierName: "Ekspedisi Kilat",
            supplierPhone: "081911223344",
            paidAmount: 85_000,
            purchasedAt: dayOffset(-10, hour: 16, minute: 45),
            createdBy: IDs.owner,
            updatedBy: IDs.owner,
            items: [
                ExpenseItem(id: UUID(), expenseId: UUID(), name: "Ongkir kirim reseller Jakarta")
            ],
            category: expenseCategories[3]
        ),
        Expense(
            id: UUID(),
            shopId: primaryShop.id,
            expenseCategoryId: IDs.salaryCategory,
            supplierName: "Upah Harian Karyawan",
            supplierPhone: nil,
            paidAmount: 450_000,
            purchasedAt: dayOffset(-14, hour: 17, minute: 30),
            createdBy: IDs.owner,
            updatedBy: IDs.owner,
            items: [
                ExpenseItem(id: UUID(), expenseId: UUID(), name: "Gaji mingguan 3 pekerja produksi")
            ],
            category: expenseCategories[4]
        ),
        Expense(
            id: UUID(),
            shopId: primaryShop.id,
            expenseCategoryId: IDs.otherCategory,
            supplierName: "Toko Perkakas Maju",
            supplierPhone: "085712349999",
            paidAmount: 65_000,
            purchasedAt: dayOffset(-18, hour: 11, minute: 20),
            createdBy: IDs.owner,
            updatedBy: IDs.owner,
            items: [
                ExpenseItem(id: UUID(), expenseId: UUID(), name: "Pisau perajang keripik stainless")
            ],
            category: expenseCategories[6]
        ),
        Expense(
            id: UUID(),
            shopId: primaryShop.id,
            expenseCategoryId: IDs.utilitiesCategory,
            supplierName: "Agen Gas Elpiji",
            supplierPhone: "082155667788",
            paidAmount: 110_000,
            purchasedAt: dayOffset(-22, hour: 13, minute: 10),
            createdBy: IDs.owner,
            updatedBy: IDs.owner,
            items: [
                ExpenseItem(id: UUID(), expenseId: UUID(), name: "Isi ulang tabung gas 12 kg")
            ],
            category: expenseCategories[2]
        )
    ]

    // MARK: - Sales Notes (Banyak Entitas)
    static let salesNotes: [SalesNote] = [
        SalesNote(
            id: UUID(),
            shopId: primaryShop.id,
            identifier: "#8612",
            customerName: "Bu Ria",
            customerPhone: "08123456789",
            totalAmount: 96_000,
            paidAmount: 96_000,
            status: .paid,
            noteFileLink: nil,
            dueAt: nil,
            soldAt: dayOffset(0, hour: 18, minute: 0),
            items: [
                SalesNoteItem(id: UUID(), salesNoteId: UUID(), name: "Keripik Tempe 100 g", quantity: 4, unitPrice: 15_000, subtotal: 60_000),
                SalesNoteItem(id: UUID(), salesNoteId: UUID(), name: "Keripik Sagu 100 g", quantity: 2, unitPrice: 18_000, subtotal: 36_000)
            ]
        ),
        SalesNote(
            id: UUID(),
            shopId: primaryShop.id,
            identifier: "#8613",
            customerName: "Bu Sherin",
            customerPhone: "081377889900",
            totalAmount: 50_000,
            paidAmount: 50_000,
            status: .paid,
            noteFileLink: nil,
            dueAt: nil,
            soldAt: dayOffset(0, hour: 17, minute: 30),
            items: [
                SalesNoteItem(id: UUID(), salesNoteId: UUID(), name: "Keripik Tempe 250 g", quantity: 2, unitPrice: 25_000, subtotal: 50_000)
            ]
        ),
        SalesNote(
            id: UUID(),
            shopId: primaryShop.id,
            identifier: "#8614",
            customerName: "Pak Andi",
            customerPhone: "081298765432",
            totalAmount: 75_000,
            paidAmount: 25_000,
            status: .dp,
            noteFileLink: nil,
            dueAt: dayOffset(4, hour: 17, minute: 0),
            soldAt: dayOffset(-1, hour: 11, minute: 20),
            items: [
                SalesNoteItem(id: UUID(), salesNoteId: UUID(), name: "Keripik Tempe 250 g", quantity: 3, unitPrice: 25_000, subtotal: 75_000)
            ]
        ),
        SalesNote(
            id: UUID(),
            shopId: primaryShop.id,
            identifier: "#8615",
            customerName: "Toko Maju Jaya",
            customerPhone: "085811223344",
            totalAmount: 450_000,
            paidAmount: 450_000,
            status: .paid,
            noteFileLink: nil,
            dueAt: nil,
            soldAt: dayOffset(-2, hour: 15, minute: 40),
            items: [
                SalesNoteItem(id: UUID(), salesNoteId: UUID(), name: "Paket Reseller Keripik Tempe (30 pcs)", quantity: 1, unitPrice: 450_000, subtotal: 450_000)
            ]
        ),
        SalesNote(
            id: UUID(),
            shopId: primaryShop.id,
            identifier: "#8616",
            customerName: "Bu Linda",
            customerPhone: "081288990011",
            totalAmount: 120_000,
            paidAmount: 120_000,
            status: .paid,
            noteFileLink: nil,
            dueAt: nil,
            soldAt: dayOffset(-4, hour: 13, minute: 10),
            items: [
                SalesNoteItem(id: UUID(), salesNoteId: UUID(), name: "Keripik Sagu 250 g", quantity: 4, unitPrice: 30_000, subtotal: 120_000)
            ]
        ),
        SalesNote(
            id: UUID(),
            shopId: primaryShop.id,
            identifier: "#8617",
            customerName: "Kedai Cemilan Enak",
            customerPhone: "081355443322",
            totalAmount: 300_000,
            paidAmount: 100_000,
            status: .dp,
            noteFileLink: nil,
            dueAt: dayOffset(5, hour: 12, minute: 0),
            soldAt: dayOffset(-6, hour: 10, minute: 50),
            items: [
                SalesNoteItem(id: UUID(), salesNoteId: UUID(), name: "Keripik Tempe 100 g (20 pcs)", quantity: 1, unitPrice: 300_000, subtotal: 300_000)
            ]
        ),
        SalesNote(
            id: UUID(),
            shopId: primaryShop.id,
            identifier: "#8618",
            customerName: "Mas Dwi",
            customerPhone: "087766554433",
            totalAmount: 35_000,
            paidAmount: 35_000,
            status: .paid,
            noteFileLink: nil,
            dueAt: nil,
            soldAt: dayOffset(-9, hour: 19, minute: 15),
            items: [
                SalesNoteItem(id: UUID(), salesNoteId: UUID(), name: "Keripik Sagu Pedas 100 g", quantity: 2, unitPrice: 17_500, subtotal: 35_000)
            ]
        ),
        SalesNote(
            id: UUID(),
            shopId: primaryShop.id,
            identifier: "#8619",
            customerName: "Oleh-Oleh Bandung Restu",
            customerPhone: "081900112233",
            totalAmount: 850_000,
            paidAmount: 850_000,
            status: .paid,
            noteFileLink: nil,
            dueAt: nil,
            soldAt: dayOffset(-12, hour: 11, minute: 0),
            items: [
                SalesNoteItem(id: UUID(), salesNoteId: UUID(), name: "Paket Keripik Tempe & Sagu (50 pcs)", quantity: 1, unitPrice: 850_000, subtotal: 850_000)
            ]
        ),
        SalesNote(
            id: UUID(),
            shopId: primaryShop.id,
            identifier: "#8620",
            customerName: "Bu Mega",
            customerPhone: "081244556677",
            totalAmount: 60_000,
            paidAmount: 60_000,
            status: .paid,
            noteFileLink: nil,
            dueAt: nil,
            soldAt: dayOffset(-15, hour: 16, minute: 20),
            items: [
                SalesNoteItem(id: UUID(), salesNoteId: UUID(), name: "Keripik Tempe Original 250 g", quantity: 2, unitPrice: 30_000, subtotal: 60_000)
            ]
        ),
        SalesNote(
            id: UUID(),
            shopId: primaryShop.id,
            identifier: "#8621",
            customerName: "Kantin Sejahtera",
            customerPhone: "085699887766",
            totalAmount: 180_000,
            paidAmount: 50_000,
            status: .dp,
            noteFileLink: nil,
            dueAt: dayOffset(2, hour: 15, minute: 0),
            soldAt: dayOffset(-20, hour: 14, minute: 30),
            items: [
                SalesNoteItem(id: UUID(), salesNoteId: UUID(), name: "Keripik Tempe Mini Pack (15 pcs)", quantity: 1, unitPrice: 180_000, subtotal: 180_000)
            ]
        )
    ]

    // MARK: - Cash Flow Transactions (derived from sales and expenses)
    static var cashFlowTransactions: [CashFlowModel] {
        func formattedTime(for date: Date) -> String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "id_ID")
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }

        func cashFlowFromSale(_ sale: SalesNote) -> CashFlowModel {
            let itemNames = sale.items?.compactMap { $0.name }.filter { !$0.isEmpty }.joined(separator: ", ") ?? "Penjualan"
            return CashFlowModel(
                id: sale.id,
                amount: sale.paidAmount,
                type: .pemasukan,
                description: "\(itemNames) · \(formattedTime(for: sale.soldAt))",
                counterpartyName: sale.customerName,
                paymentStatus: sale.status.title,
                date: sale.soldAt,
                income: sale
            )
        }

        func cashFlowFromExpense(_ expense: Expense) -> CashFlowModel {
            let itemNames = expense.items?
                .compactMap { $0.name }
                .filter { !$0.isEmpty }
                .joined(separator: ", ") ?? "Biaya Operasional"

            return CashFlowModel(
                id: expense.id,
                amount: expense.paidAmount,
                type: .pengeluaran,
                description: "\(itemNames) · \(formattedTime(for: expense.purchasedAt))",
                counterpartyName: expense.supplierName ?? "Pengeluaran",
                paymentStatus: PaymentStatus.paid.title,
                date: expense.purchasedAt,
                expense: expense
            )
        }

        return (salesNotes.map(cashFlowFromSale) + expenses.map(cashFlowFromExpense)).sorted { $0.date > $1.date }
    }
}
