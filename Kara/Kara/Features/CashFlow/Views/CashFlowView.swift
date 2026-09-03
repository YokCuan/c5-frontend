import SwiftUI

public struct CashFlowView: View {
    @StateObject public var viewModel = CashFlowViewModel()
    @State private var scrollOffset: CGFloat = 0
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            let isScrolled = scrollOffset > 30
            
            ZStack(alignment: .top) {
                VStack{
                    Color(.karaBlue)
                        .ignoresSafeArea(.all)
                    Color(.systemGroupedBackground)
                        .ignoresSafeArea(.all)
                }
                
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 24) {                            Text("Arus Kas")
                            .font(isScrolled ? .title2 : .largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .animation(.easeOut(duration: 0.2), value: isScrolled)
                        
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
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
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
                        ZStack {
                            Color(.systemGroupedBackground)
                                .ignoresSafeArea(.all)
                            
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
                                                bottomTrailingRadius: 24,
                                            )
                                        )
                                )
                                
                                VStack(spacing: 16) {
                                    if viewModel.isLoading {
                                        ProgressView()
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .padding(.top, 80)
                                    } else if viewModel.transactions.isEmpty {
                                        VStack(spacing: 8) {
                                            Image(systemName: "doc.text.magnifyingglass")
                                                .font(.largeTitle)
                                                .foregroundStyle(.gray)
                                            Text("Belum ada transaksi")
                                                .font(.subheadline)
                                                .foregroundStyle(.gray)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.top, 80)
                                    } else {
                                        LazyVStack(spacing: 16) {
                                            ForEach(viewModel.groupedTransactions, id: \.key) { group in
                                                VStack(alignment: .leading, spacing: 10) {
                                                    Text(group.key, style: .date)
                                                        .font(.caption.bold())
                                                        .foregroundStyle(.gray)
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
                        .frame(
                            maxHeight: .infinity)
                    }
                    .refreshable {
                        await viewModel
                            .loadTransactions(
                                shopId: AppMockData.primaryShop.id
                            )
                    }
                    
                }
            }
            .task {
                await viewModel.loadTransactions(shopId: AppMockData.primaryShop.id)
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

#if DEBUG
extension CashFlowViewModel {
    static var preview: CashFlowViewModel {
        let vm = CashFlowViewModel()
        return vm
    }
}
#endif

#Preview {
    CashFlowView()
}
