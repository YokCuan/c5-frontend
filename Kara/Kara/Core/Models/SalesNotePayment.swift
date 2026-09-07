import Foundation

public struct SalesNotePayment: Identifiable, Codable, Hashable {
    public var id: UUID
    public var salesNoteId: UUID
    public var paymentAttempt: Int
    public var paidAmount: Double
    public var paidAt: Date
}
