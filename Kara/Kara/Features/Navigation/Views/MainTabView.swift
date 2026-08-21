import SwiftUI

public struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showAddRecord = false
    
    public init() {}
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                CashFlowView()
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle")
                        Text("Arus Kas")
                    }
                    .tag(0)
                
                RekapView()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Rekap")
                    }
                    .tag(1)
            }
            
            // Custom Floating Action Button
            Button(action: {
                showAddRecord = true
            }) {
                Image(systemName: "plus")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
            }
            .offset(y: -20)
        }
        .sheet(isPresented: $showAddRecord) {
            AddRecordView()
        }
    }
}

#Preview {
    MainTabView()
}
