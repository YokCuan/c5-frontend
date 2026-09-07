import Foundation

public enum CashFlowItemType: String, Codable {
    case salesNote = "sales_note"
    case expense = "expense"
}

public struct CashFlowModel: Identifiable, Codable {
    public let id: UUID
    public let uniqueId: UUID
    public let amount: Double
    public let occurredAt: Date
    public let type: CashFlowItemType
    public let categoryType: String
    public let title: String
    public let description: String?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        
        self.uniqueId = UUID()
        
        self.amount = try container.decode(Double.self, forKey: .amount)
        self.occurredAt = try container.decode(Date.self, forKey: .occurredAt)
        self.type = try container.decode(CashFlowItemType.self, forKey: .type)
        self.categoryType = try container.decode(String.self, forKey: .categoryType)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
    }

    public init(
        id: UUID,
        uniqueId: UUID = UUID(),
        amount: Double,
        occurredAt: Date,
        type: CashFlowItemType,
        categoryType: String,
        title: String,
        description: String? = nil
    ) {
        self.id = id
        self.uniqueId = uniqueId
        self.amount = amount
        self.occurredAt = occurredAt
        self.type = type
        self.categoryType = categoryType
        self.title = title
        self.description = description
    }

    private enum CodingKeys: String, CodingKey {
        case id, amount, occurredAt, type, categoryType, title, description
    }
}
