import SwiftUI

public struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showAddRecord = false
    @State private var navigationRoute: AppRoute?
    
    public init() {}
    
    
    public var body: some View {
        NavigationStack{
            TabView(selection: $selectedTab) {
                Tab("Arus Kas", systemImage: "dollarsign.circle.fill", value: 0) {
                    CashFlowView()
                }
                
                Tab("Rekap", systemImage: "chart.bar.fill", value: 1) {
                    Penjualan()
                }
                
                Tab("Tambah", systemImage: "plus", value: 2, role: .search) {
                    Color.clear
                }
            }
            
            .sheet(isPresented: $showAddRecord) {
                IncomeExpenseChoiceSheet(navigationRoute: $navigationRoute)
            }
            .onChange(of: selectedTab) { oldTab, newTab in
                if newTab == 2 {
                    showAddRecord = true
                    selectedTab = oldTab
                }
            }
            .navigationDestination(item: $navigationRoute) { route in
                switch route {
                case .addIncome:
                    AddIncomeView()
                case .addExpense:
                    ExpenseFormView(viewModel: ExpenseFormViewModel(mode: .add))
                }
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(CategoryStore.shared)
}
