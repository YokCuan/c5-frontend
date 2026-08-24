import SwiftUI

public struct IncomeFormView: View {
    @StateObject public var viewModel = AddIncomeViewModel()
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
//        Form {
//            Section(header: Text("Detail Pemasukan")) {
//                TextField("Deskripsi", text: $viewModel.incomeDescription)
//                
//                TextField("Jumlah (Rp)", value: $viewModel.amount, format: .number)
//                    .keyboardType(.numberPad)
//            }
//            
//            Section(header: Text("Pembeli")) {
//                TextField("Nama Pembeli (opsional)", text: $viewModel.buyerName)
//                
//                Picker("Status Pembayaran", selection: $viewModel.paymentStatus) {
//                    ForEach(PaymentStatus, id: \.self) { status in
//                        Text(status.title).tag(status)
//                    }
//                }
//            }
//            
//            Section {
//                DatePicker("Tanggal", selection: $viewModel.transactionDate, displayedComponents: .date)
//            }
//            
//            Section {
//                Button {
//                    Task { await viewModel.save() }
//                } label: {
//                    if viewModel.isLoading {
//                        ProgressView()
//                            .frame(maxWidth: .infinity)
//                    } else {
//                        Text("Simpan Pemasukan")
//                            .frame(maxWidth: .infinity)
//                            .fontWeight(.bold)
//                    }
//                }
//                .disabled(viewModel.isLoading)
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
    IncomeFormView()
}
