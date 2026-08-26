import SwiftUI

public struct CashFlowView: View {
    @StateObject public var viewModel = CashFlowViewModel()
    @State var scrollOffset: CGFloat = 0
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            
            ZStack(alignment: .top) {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                LinearGradient(
                    gradient: Gradient(colors: [.karaBlueDark, .karaBlue]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 400)
                .cornerRadius(20)
                .ignoresSafeArea(edges: .top)
                .offset(y: -max(0, scrollOffset))
                
                VStack(spacing: 0){
                    // Filter Section
                    SearchBarFilterButton(viewModel: viewModel)
                    
                    ScrollView {
                        // Summary Cards
                        HStack(spacing: 16) {
                            CashFlowSummaryCard(title: "Total Pemasukan", amount: viewModel.totalIncome, isIncome: true)
                            CashFlowSummaryCard(title: "Total Pengeluaran", amount: viewModel.totalExpense, isIncome: false)
                        }
                        .padding(.horizontal)
                        
                        // Transactions List
                        if viewModel.isLoading {
                            ProgressView()
                                .padding(.top, 40)
                        } else if viewModel.transactions.isEmpty {
                            VStack {
                                Image(systemName: "doc.text.magnifyingglass")
                                    .font(.largeTitle)
                                    .foregroundColor(.secondary)
                                Text("Belum ada transaksi")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.top, 60)
                        } else {
                            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                                ForEach(viewModel.groupedTransactions, id: \.key) { group in
                                    Section(header:
                                                Text(group.key, style: .date)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                        .padding(.vertical)
                                        .background(Color(.systemGroupedBackground))
                                    ) {
                                        ForEach(group.value) { transaction in
                                            CashFlowTransactionRow(transaction: transaction)
                                                .padding(.horizontal)
                                            Divider()
                                                .padding(.leading)
                                        }
                                    }
                                }
                            }
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                }
                .onScrollGeometryChange(for: CGFloat.self) { geometry in
                    geometry.contentOffset.y
                } action: { oldValue, newValue in
                    scrollOffset = newValue
                }
            }
            .navigationTitle("Arus Kas")
            .task {
                await viewModel.loadTransactions()
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}

#Preview {
    CashFlowView()
}
