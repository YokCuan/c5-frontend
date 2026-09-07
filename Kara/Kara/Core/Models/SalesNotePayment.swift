//
//  SalesNotePayment.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 07/09/26.
//

import Foundation

public struct SalesNotePayment: Identifiable, Codable, Hashable {
    public var id: UUID
    public var salesNoteId: UUID
    public var paymentAttempt: Int
    public var paidAmount: Double
    public var paidAt: Date
}
