import Foundation

public struct CashFlowModel: Identifiable, Codable {
    public var id: String
    public var amount: Int
    public var type: TransactionType
    public var description: String
    public var date: Date
    public var counterpartyName: String
    public var paymentStatus: String?
    
    public init(id: String = UUID().uuidString, amount: Int, type: TransactionType, description: String, date: Date = Date(), counterpartyName: String, paymentStatus: String? = nil) {
        self.id = id
        self.amount = amount
        self.type = type
        self.description = description
        self.date = date
        self.counterpartyName = counterpartyName
        self.paymentStatus = paymentStatus
    }
}
