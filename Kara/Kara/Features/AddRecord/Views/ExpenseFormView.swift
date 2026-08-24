import SwiftUI

public struct ExpenseFormView: View {
    @StateObject public var viewModel = AddExpenseViewModel()
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
//        Form {
//            Section(header: Text("Detail Pengeluaran")) {
//                TextField("Deskripsi (opsional)", text: $viewModel.expenseDescription)
//                
//                TextField("Jumlah (Rp)", value: $viewModel.amount, format: .number)
//                    .keyboardType(.numberPad)
//            }
//            
//            Section(header: Text("Toko / Supplier")) {
//                TextField("Nama Toko (opsional)", text: $viewModel.storeName)
//                TextField("Kontak (opsional)", text: $viewModel.storeContact)
//            }
//            
//            Section {
//                DatePicker("Tanggal", selection: $viewModel.transactionDate, displayedComponents: .date)
//            }
//        }
//        .navigationTitle("Tambah Pengeluaran")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button("Simpan") {
//                    Task {
//                        await viewModel.save()
//                    }
//                }
//                .disabled(viewModel.isLoading)
//            }
//            
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button("Batal") {
//                    dismiss()
//                }
//            }
//        }
//        .overlay {
//            if viewModel.isLoading {
//                ProgressView("Menyimpan...")
//                    .padding()
//                    .background(Color(.systemBackground))
//                    .cornerRadius(10)
//                    .shadow(radius: 10)
//            }
//        }
//        .onChange(of: viewModel.isSaved) { saved in
//            if saved {
//                dismiss()
//            }
//        }
//        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
//            Button("OK") { viewModel.errorMessage = nil }
//        } message: {
//            Text(viewModel.errorMessage ?? "")
//        }
    }
}

#Preview {
    ExpenseFormView()
}
