import SwiftUI

public struct CashFlowView: View {
    @StateObject public var viewModel = CashFlowViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Filter Section
                    HStack {
                        DatePicker("Dari", selection: $viewModel.startDate, displayedComponents: .date)
                            .labelsHidden()
                        Text("-")
                        DatePicker("Sampai", selection: $viewModel.endDate, displayedComponents: .date)
                            .labelsHidden()
                        
                        Spacer()
                        
                        Button("Filter") {
                            Task { await viewModel.loadTransactions() }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.horizontal)
                    
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
                            Text("Tidak ada transaksi")
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
                                        .padding(.vertical, 8)
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
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
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
