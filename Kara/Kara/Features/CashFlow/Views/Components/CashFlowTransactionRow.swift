import SwiftUI

public struct CashFlowTransactionRow: View {
    public let transaction: CashFlowModel
    
    public init(transaction: CashFlowModel) {
        self.transaction = transaction
    }
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.description)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                if !transaction.counterpartyName.isEmpty {
                    Text(transaction.counterpartyName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(transaction.type == .pemasukan ? "+ Rp \(transaction.amount)" : "- Rp \(transaction.amount)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(transaction.type == .pemasukan ? .green : .red)
                
                if let status = transaction.paymentStatus {
                    Text(status)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(4)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    CashFlowTransactionRow(transaction: CashFlowModel(amount: 150000, type: .pemasukan, description: "Penjualan Keripik", counterpartyName: "Budi", paymentStatus: "Lunas"))
}
