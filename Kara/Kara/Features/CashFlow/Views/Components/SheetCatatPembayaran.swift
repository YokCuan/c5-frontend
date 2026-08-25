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
    
    @State private var bayar: String = ""
    
    var body: some View {
        VStack {
            VStack{
                Text("Catat Pembayaran")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text(customerName)
                    Text("· Sisa")
                    Text(remainingAmount.formatted(.currency(code: "IDR")))
                }
                .font(.callout)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
                .frame(height: 24)
            
            VStack {
                Text("Jumlah Pembayaran")
                    .font(.callout)
                    .fontWeight(.regular)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text("Rp")
                        .font(.callout)
                        .fontWeight(.regular)
                        .foregroundStyle(.secondary)
                    TextField("Catat pembayaran", text: $bayar)
                        .foregroundColor(Color.primary)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
                .background(Color.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Button {
                    recordPayment()
                } label: {
                    Text("Catat Pembayaran")
                        .padding(.vertical)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 48))
                }
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
