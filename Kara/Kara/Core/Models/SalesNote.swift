//
//  Sales.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 24/08/26.
//

import Foundation

public struct SalesNote: Identifiable, Codable {
    public var id: UUID
    public var shopId: UUID
    public var identifier: String
    public var customerName: String
    public var customerPhone: String?
    public var totalAmount: Double
    public var paidAmount: Double
    public var status: PaymentStatus
    public var noteFileLink: String?
    public var dueAt: Date?
    public var soldAt: Date
    public var items: [SalesNoteItem]?
}
