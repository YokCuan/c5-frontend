import SwiftUI

public struct CashFlowSummaryCard: View {
    public let title: String
    public let amount: Double
    public let isIncome: Bool
    
    public init(title: String, amount: Double, isIncome: Bool) {
        self.title = title
        self.amount = amount
        self.isIncome = isIncome
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(isIncome ? Color.green : Color.red)
                    .frame(width: 32, height: 32)
                    .background(
                        isIncome ? Color.green.opacity(0.15) : Color.red.opacity(0.15)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.secondary)
            }
            
            Text(amount.toIDR)
                .font(.title3.bold())
                .foregroundStyle(
                    isIncome ? Color.green : Color.red
                )
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
}

#Preview {
    ZStack {
        Color(red: 0.05, green: 0.22, blue: 0.38)
            .ignoresSafeArea()
        
        HStack(spacing: 14) {
            CashFlowSummaryCard(title: "Uang Masuk", amount: 120000, isIncome: true)
            CashFlowSummaryCard(title: "Uang Keluar", amount: 350000, isIncome: false)
        }
        .padding()
    }
}
