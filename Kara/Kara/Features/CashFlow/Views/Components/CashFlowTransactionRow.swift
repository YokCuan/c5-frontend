import SwiftUI

public struct CashFlowTransactionRow: View {
    public let transaction: CashFlowModel
    
    public init(transaction: CashFlowModel) {
        self.transaction = transaction
    }
    
    private var isIncome: Bool {
        transaction.type == .pemasukan
    }
    
    private var statusColor: Color {
        isIncome ? Color(red: 0.12, green: 0.75, blue: 0.35) : Color(red: 0.98, green: 0.28, blue: 0.28)
    }
    
    public var body: some View {
        NavigationLink {
            if isIncome, let salesNote = transaction.income {
                DetailPemasukanView(note: salesNote)
            } else if let expense = transaction.expense {
                EditExpenseView(expense: expense)
            }
        } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(transaction.counterpartyName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Text(
                        isIncome
                        ? "Penjualan"
                        : (transaction.expense?.category?.name ?? "Pengeluaran")
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text(
                    isIncome
                    ? "+ \(transaction.amount.toIDR)"
                    : "- \(transaction.amount.toIDR)"
                )
                .font(.headline.bold())
                .foregroundStyle(statusColor)
                
                Image(systemName: "chevron.right")
                    .font(.subheadline.bold())
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(alignment: .leading) {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(statusColor, lineWidth: 3.5)
                    .mask(
                        HStack {
                            Rectangle().frame(width: 4)
                            Spacer()
                        }
                    )
            }
            .shadow(color: Color.black.opacity(0.03), radius: 6, y: 2)
        }
        .buttonStyle(.plain) 
    }
}
