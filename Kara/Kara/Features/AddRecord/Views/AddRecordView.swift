import SwiftUI

public struct AddRecordView: View {
    @State private var selectedTab = 0
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Tipe Transaksi", selection: $selectedTab) {
                    Text("Pemasukan").tag(0)
                    Text("Pengeluaran").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                .background(Color(.systemGroupedBackground))
                
                if selectedTab == 0 {
                    AddIncomeView()
                } else {
                    ExpenseFormView()
                }
            }
            .navigationTitle("Tambah Catatan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Tutup") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddRecordView()
}
