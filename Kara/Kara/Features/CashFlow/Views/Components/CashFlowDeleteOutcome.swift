//
//  DeleteIncome.swift
//  Kara
//
//  Created by Shelly Mutiara Haq on 24/08/26.
//

import SwiftUI

struct CashFlowDeleteOutcome: View {
    @Environment(\.dismiss) private var dismiss
    
    let expenseId: UUID
    let shopId: UUID
    var onDeleteSuccess: (() -> Void)?
    
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "trash")
                .font(.title2)
                .foregroundStyle(Color.red)
                .frame(width: 40, height: 40)
                .background(Color.red.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text("Hapus Pengeluaran?")
                .font(.body)
                .fontWeight(.bold)
            
            Text("Transaksi ini akan dihapus secara permanen dan tidak dapat dibatalkan.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
            
            if let errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
            
            Button {
                Task {
                    isLoading = true
                    errorMessage = nil
                    do {
                        try await APIService.shared
                            .deleteExpense(id: expenseId, shopId: shopId)
                        isLoading = false
                        onDeleteSuccess?()
                        dismiss()
                    } catch {
                        isLoading = false
                        errorMessage = "Gagal menghapus: \(error.localizedDescription)"
                    }
                }
            } label: {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Hapus")
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.red)
            .foregroundColor(.white)
            .fontWeight(.semibold)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .disabled(isLoading)
            
            Button("Batalkan") {
                dismiss()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.5))
            .foregroundColor(.black)
            .fontWeight(.semibold)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .disabled(isLoading)
        }
        .padding(20)
    }
}

#Preview {
    CashFlowDeleteOutcome(expenseId: UUID(), shopId: UUID())
}
