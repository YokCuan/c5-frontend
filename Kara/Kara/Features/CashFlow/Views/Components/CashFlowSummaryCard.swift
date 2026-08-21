import SwiftUI

public struct CashFlowSummaryCard: View {
    public let title: String
    public let amount: Int
    public let isIncome: Bool
    
    public init(title: String, amount: Int, isIncome: Bool) {
        self.title = title
        self.amount = amount
        self.isIncome = isIncome
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Rp \(amount)")
                .font(.headline)
                .foregroundColor(isIncome ? .green : .red)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    CashFlowSummaryCard(title: "Total Pemasukan", amount: 150000, isIncome: true)
}
