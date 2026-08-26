import SwiftUI

public struct CashFlowView: View {
    @StateObject public var viewModel = CashFlowViewModel()
    @State var scrollOffset: CGFloat = 0
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            
            let titleOpacity = max(0, 1 - (scrollOffset / 40.0))
            let titleHeight = max(0, 40 - scrollOffset)
            
            ZStack(alignment: .top) {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea(.all)
                
                LinearGradient(
                    gradient: Gradient(colors: [.karaBlueDark, .karaBlue]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 360)
                .cornerRadius(20)
                .ignoresSafeArea(edges: .top)
                .offset(y: -max(0, scrollOffset))
                
                VStack(spacing: 0){
                    VStack(alignment: .leading, spacing: 8) {
                        
                        // Teks Judul "Arus Kas" yang Menyusut & Hilang
                        if titleHeight > 0 {
                            Text("Arus Kas")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(UIColor.secondarySystemBackground))
                                .padding(.horizontal)
                                .opacity(titleOpacity)
                                .frame(height: titleHeight)
                                .clipped()
                        }
                        
                        // Filter Section (Tetap Stay di Atas setelah Judul Hilang)
                        SearchBarFilterButton(viewModel: viewModel)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            // Summary Cards
                            HStack(spacing: 16) {
                                CashFlowSummaryCard(title: "Uang Masuk", amount: Double(viewModel.totalIncome), isIncome: true)
                                CashFlowSummaryCard(
                                    title: "Uang Keluar",
                                    amount: Double(viewModel.totalExpense),
                                    isIncome: false
                                )
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
                    // Menangkap posisi Scroll Y secara realtime
                    .onScrollGeometryChange(for: CGFloat.self) { geometry in
                        geometry.contentOffset.y
                    } action: { oldValue, newValue in
                        scrollOffset = newValue
                    }
                }
            }
            // Sembunyikan Nav Bar standar bawaan iOS agar tidak bentrok dengan Custom Header
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
