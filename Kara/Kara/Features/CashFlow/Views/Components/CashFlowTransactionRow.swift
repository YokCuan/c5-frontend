import SwiftUI

public struct CashFlowTransactionRow: View {
    public let transaction: CashFlowModel
    
    public init(transaction: CashFlowModel) {
        self.transaction = transaction
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            
            // MARK: - Left Content
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.counterpartyName)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(transaction.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // MARK: - Amount
            Text(
                transaction.type == .pemasukan
                ? "+ Rp \(transaction.amount)"
                : "- Rp \(transaction.amount)"
            )
            .font(.headline)
            .fontWeight(.bold)
            .foregroundStyle(
                transaction.type == .pemasukan
                ? .green
                : .red
            )
            
            // MARK: - Chevron
            Image(systemName: "chevron.right")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(.systemBackground))
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
        .overlay(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    transaction.type == .pemasukan
                    ? Color.green
                    : Color.red,
                    lineWidth: 3
                )
                .mask(
                    HStack {
                        Rectangle()
                            .frame(width: 3)
                        Spacer()
                    }
                )
        }
    }
}

#Preview {
    CashFlowTransactionRow(
        transaction: CashFlowModel(
            amount: 50000,
            type: .pemasukan,
            description: "Penjualan · 18:00",
            counterpartyName: "Bu Ria",
            paymentStatus: "Lunas"
        )
    )
    .padding()
}
