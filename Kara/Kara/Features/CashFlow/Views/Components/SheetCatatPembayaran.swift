//
//  SheetCatatPembayaran.swift
//  Kara
//
//  Created by Samuel Bonardo on 25/08/26.
//

import SwiftUI

struct SheetCatatPembayaran: View {
    @Environment(\.dismiss) private var dismiss
    
    let salesNoteId: UUID
    let shopId: UUID
    let userId: UUID
    let customerName: String
    let remainingAmount: Double
    var onSuccess: (() -> Void)? = nil
    
    @State private var bayar: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    public init(salesNoteId: UUID, shopId: UUID, userId: UUID, customerName: String, remainingAmount: Double, onSuccess: (() -> Void)? = nil) {
        self.salesNoteId = salesNoteId
        self.shopId = shopId
        self.userId = userId
        self.customerName = customerName
        self.remainingAmount = remainingAmount
        self.onSuccess = onSuccess
    }
    
    private var parsedBayarAmount: Double? {
        let cleanedText = bayar.replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: ".", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return Double(cleanedText)
    }
    
    private var isAmountValid: Bool {
        guard let amount = parsedBayarAmount else { return false }
        return amount > 0 && amount <= remainingAmount
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Catat Pembayaran")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 4) {
                    Text(customerName)
                    Text("· Sisa")
                    Text(remainingAmount.formatted(.currency(code: "IDR")))
                }
                .font(.subheadline)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
                .frame(height: 12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Jumlah Pembayaran")
                    .font(.footnote)
                    .fontWeight(.regular)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 8) {
                    Text("Rp")
                        .font(.callout)
                        .fontWeight(.regular)
                        .foregroundStyle(.secondary)
                    TextField("0", text: $bayar)
                        .foregroundColor(Color.primary)
                        .font(.title2)
                        .fontWeight(.bold)
                        .keyboardType(.numberPad)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                if let errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                
                Button {
                    recordPayment()
                } label: {
                    Group {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Catat Pembayaran")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.vertical)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .background(isAmountValid ? Color.blue : Color.gray.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 48))
                }
                .disabled(!isAmountValid || isLoading)
            }
        }
        .padding(24)
        .contentShape(Rectangle())
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    private func recordPayment() {
            guard let amount = parsedBayarAmount else { return }
            
            Task {
                isLoading = true
                errorMessage = nil
                
                do {
                    try await APIService.shared.recordPayment(
                        salesNoteId: salesNoteId,
                        shopId: shopId,
                        paidAmount: amount,
                        userId: userId
                    )
                    isLoading = false
                    dismiss()
                    onSuccess?()
                } catch {
                    errorMessage = "Gagal mencatat pembayaran: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
}

#Preview {
    struct PreviewContainer: View {
        @State private var isShowingSheet = true
        
        var body: some View {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
                .sheet(isPresented: $isShowingSheet) {
                    SheetCatatPembayaran(
                        salesNoteId: UUID(),
                        shopId: AppMockData.primaryShop.id,
                        userId: AppMockData.currentUser.id,
                        customerName: "Bu Sherin",
                        remainingAmount: 50000
                    )
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                }
        }
    }
    
    return PreviewContainer()
}
