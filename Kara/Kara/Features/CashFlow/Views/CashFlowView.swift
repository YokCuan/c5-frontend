import SwiftUI

public struct CashFlowView: View {
    @StateObject public var viewModel = CashFlowViewModel()
    @State private var scrollOffset: CGFloat = 0
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            let titleOpacity = max(0, 1 - (scrollOffset / 35.0))
            let titleHeight = max(0, 36 - scrollOffset)
            
            ZStack(alignment: .top) {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 24) {
                        if titleHeight > 0 {
                            Text("Arus Kas")
                                .font(.largeTitle.bold())
                                .foregroundStyle(.white)
                                .padding(.top, 10)
                                .padding(.horizontal, 16)
                                .opacity(titleOpacity)
                                .frame(height: titleHeight)
                                .clipped()
                        }
                        
                        SearchBarFilterButton(
                            viewModel: viewModel,
                            searchText: $viewModel.searchText,
                            selectedPaymentStatus: $viewModel.selectedPaymentStatus,
                            selectedCategory: $viewModel.selectedCategory,
                            startDate: $viewModel.startDate,
                            endDate: $viewModel.endDate,
                            useCustomDateRange: $viewModel.useCustomDateRange,
                            minAmountFilter: $viewModel.minAmountFilter,
                            maxAmountFilter: $viewModel.maxAmountFilter
                        )
                    }
                    .padding(.vertical)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.karaBlueDark, .karaBlue]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        
                        .ignoresSafeArea(edges: .top)
                    )
                    .zIndex(1)
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            VStack(spacing: 0) {
                                HStack(spacing: 14) {
                                    CashFlowSummaryCard(
                                        title: "Uang Masuk",
                                        amount: Double(viewModel.totalIncome),
                                        isIncome: true
                                    )
                                    CashFlowSummaryCard(
                                        title: "Uang Keluar",
                                        amount: Double(viewModel.totalExpense),
                                        isIncome: false
                                    )
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 22)
                            }
                            .background(
                                Color.karaBlue
                                    .clipShape(
                                        UnevenRoundedRectangle(
                                            bottomLeadingRadius: 24,
                                            bottomTrailingRadius: 24
                                        )
                                    )
                            )
                            VStack(spacing: 16) {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .padding(.top, 40)
                                } else if viewModel.transactions.isEmpty {
                                    VStack(spacing: 8) {
                                        Image(systemName: "doc.text.magnifyingglass")
                                            .font(.largeTitle)
                                            .foregroundStyle(.secondary)
                                        Text("Belum ada transaksi")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(.top, 60)
                                } else {
                                    LazyVStack(spacing: 16) {
                                        ForEach(viewModel.groupedTransactions, id: \.key) { group in
                                            VStack(alignment: .leading, spacing: 10) {
                                                Text(group.key, style: .date)
                                                    .font(.caption.bold())
                                                    .foregroundStyle(.secondary)
                                                    .padding(.horizontal, 4)
                                                
                                                VStack(spacing: 10) {
                                                    ForEach(group.value) { transaction in
                                                        CashFlowTransactionRow(transaction: transaction)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.top, 16)
                                    .padding(.bottom, 90)
                                }
                            }
                        }
                    }
                    .onScrollGeometryChange(for: CGFloat.self) { geometry in
                        geometry.contentOffset.y
                    } action: { _, newValue in
                        scrollOffset = newValue
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
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
