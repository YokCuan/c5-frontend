import Foundation

public enum CashFlowItemType: String, Codable {
    case salesNote = "sales_note"
    case expense = "expense"
}

public struct CashFlowModel: Identifiable, Codable {
    public let id: UUID
    public let amount: Double
    public let occurredAt: Date
    public let type: CashFlowItemType
    public let categoryType: String
    public let title: String
    public let description: String?

    public init(
        id: UUID,
        amount: Double,
        occurredAt: Date,
        type: CashFlowItemType,
        categoryType: String,
        title: String,
        description: String? = nil
    ) {
        self.id = id
        self.amount = amount
        self.occurredAt = occurredAt
        self.type = type
        self.categoryType = categoryType
        self.title = title
        self.description = description
    }
}
