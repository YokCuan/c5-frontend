//
//  SheetCatatPembayaran.swift
//  Kara
//
//  Created by Samuel Bonardo on 25/08/26.
//

import SwiftUI

struct SheetCatatPembayaran: View {
    
    let customerName: String
    let remainingAmount: Double
    
    @State private var bayar: Int = 0
    
    var body: some View {
        VStack (spacing: 32) {
            VStack{
                Text("Catat Pembayaran")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text(customerName)
                    Text("· Sisa")
                    Text(remainingAmount.formatted(.currency(code: "IDR")))
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack {
                Text("Jumlah Pembayaran")
                    .font(.footnote)
                    .fontWeight(.regular)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text("Rp ")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundStyle(.gray)
                    TextField("0", value: $bayar, format: .number.locale(Locale(identifier: "id_ID")))
                        .keyboardType(.numberPad)                        .foregroundColor(Color.black)
                        .font(.body)
                        .fontWeight(.bold)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Button {
                recordPayment()
            } label: {
                Text("Catat Pembayaran")
                    .padding(.vertical)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 48))
            }
        }
        
        .padding(.horizontal)
    }
    
    private func recordPayment() {
        Task {
            //later
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
                        customerName: "Bu Sherin",
                        remainingAmount: 5000
                    )
                    .presentationDetents([.height(400)])
                    .presentationDragIndicator(.visible)
                }
        }
    }
    
    return PreviewContainer()
}
