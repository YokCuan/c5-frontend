import Foundation

public enum CashflowTransactionType: String {
    case pemasukan
    case pengeluaran
}

public struct CashFlowModel: Identifiable {
    public let id: UUID
    public let amount: Double
    public let type: CashflowTransactionType
    public let description: String
    public let counterpartyName: String // Customer Name atau Supplier Name
    public let paymentStatus: String
    public let date: Date
    public let income: SalesNote?
    public let expense: Expense?
    
    public init(
        id: UUID = UUID(),
        amount: Double,
        type: CashflowTransactionType,
        description: String,
        counterpartyName: String,
        paymentStatus: String,
        date: Date,
        income: SalesNote? = nil,
        expense: Expense? = nil
    ) {
        self.id = id
        self.amount = amount
        self.type = type
        self.description = description
        self.counterpartyName = counterpartyName
        self.paymentStatus = paymentStatus
        self.date = date
        self.income = income
        self.expense = expense
    }
}
