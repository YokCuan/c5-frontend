import SwiftUI

public struct RekapView: View {
    @StateObject public var viewModel = RekapViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Net Balance Card
                    VStack(spacing: 8) {
                        Text("Saldo Bersih")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Rp \(viewModel.netBalance)")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(viewModel.netBalance >= 0 ? .green : .red)
                    }
                    .padding(.vertical, 30)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                    
                    // Detail Breakdown
                    VStack(spacing: 0) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Pemasukan")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Rp \(viewModel.totalIncome)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                            Spacer()
                            Image(systemName: "arrow.down.left.circle.fill")
                                .foregroundColor(.green)
                                .font(.title)
                        }
                        .padding()
                        
                        Divider()
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Pengeluaran")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Rp \(viewModel.totalExpense)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                            }
                            Spacer()
                            Image(systemName: "arrow.up.right.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                        }
                        .padding()
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Rekap Transaksi")
            .task {
                await viewModel.loadRekap(shopId: AppMockData.primaryShop.id)
            }
        }
    }
}

#Preview {
    RekapView()
}
