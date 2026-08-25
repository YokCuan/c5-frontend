//
//  DetailPemasukanView.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 23/08/26.
//

import SwiftUI

public struct DetailPemasukanView: View {
    
    let note: SalesNote
    @State private var isShowingDelSheet = false
    
    public var body: some View {
        VStack(spacing: 20) {
            //Catd
            VStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.green)
                    .frame(height: 4)
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(note.customerName)
                            .font(.title2.bold())
                        Text("Penjualan")
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("JUMLAH DITERIMA")
                            .font(.caption2.bold())
                            .foregroundStyle(.gray)
                        Text("+ \(note.paidAmount.toIDR)")
                            .font(.title.bold())
                            .foregroundStyle(.green)
                    }
                    
                    Divider()
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("Waktu")
                                .foregroundStyle(.gray)
                            Spacer()
                            Text(note.soldAt.formattedTime())
                                .bold()
                        }
                        HStack {
                            Text("Tanggal")
                                .foregroundStyle(.gray)
                            Spacer()
                            Text(note.soldAt.formattedDate())
                                .bold()
                        }
                    }
                }
                .padding()
            }
            .background(.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.05), radius: 5, y: 4)
            
            //Warning
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.circle")
                Text("Pemasukan dari penjualan tidak bisa diedit. Ubah data di halaman Penjualan")
                Spacer()
            }
            .font(.footnote)
            .foregroundStyle(.blue)
            .padding(15)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            
            
            //DelButton
            Button(action: {isShowingDelSheet = true}) {
                Text("Hapus Pemasukan")
                    .font(.body.bold())
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
            }
            .sheet(isPresented: $isShowingDelSheet){
                DeleteIncome()
                    .presentationDetents([.fraction(0.5), .height(.infinity)])
                    .presentationDragIndicator(.visible)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Detail Pemasukan")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Not Paid") {
    let dummyShop = Shop(
        id: UUID(),
        ownerId: UUID(),
        name: "Keripik Bu Ria",
        description: "Usaha Keripik Tempe Sagu"
    )
    
    let dummyNote = SalesNote(
        id: UUID(),
        shopId: dummyShop.id,
        identifier: "#8612",
        customerName: "Bu Jess",
        customerPhone: "08123456789",
        totalAmount: 30000,
        paidAmount: 30000,
        status: .paid,
        noteFileLink: nil,
        dueAt: Date(),
        soldAt: Date(),
        items: [
            SalesNoteItem(id: UUID(), salesNoteId: UUID(), name: "Keripik Tempe 100 g", quantity: 2, unitPrice: 15000, subtotal: 30000)
        ]
    )
    
    ZStack {
        DetailPemasukanView(note: dummyNote)
        
    }
}

