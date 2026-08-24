//
//  SalesCard.swift
//  Kara
//
//  Created by Shelly Mutiara Haq on 24/08/26.
//


import SwiftUI

struct SalesCard: View {
    let salesNote: SalesNote
    private var remainingAmount: Double {
            max(0, salesNote.totalAmount - salesNote.paidAmount)
        }
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text (salesNote.customerName)
                    .font(.headline)
                Spacer()
                Text ("DP")
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.orange)
                    .foregroundStyle(Color.white)
                    .clipShape(Capsule())
            }
            VStack (spacing: 8) {
                HStack {
                    Text ("Total")
                    Spacer()
                    Text (salesNote.totalAmount.toIDR)
                        .fontWeight(.bold)
                }
                HStack {
                    Text ("Sudah Dibayar")
                    Spacer()
                    Text (salesNote.paidAmount.toIDR)
                        .fontWeight(.bold)
                }
            }
            .foregroundStyle(Color.secondary)
            
            Divider ()
            
            HStack {
                Text ("Sisa Pembayaran")
                Spacer()
                Text (remainingAmount.toIDR)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.red)
            }
            .foregroundStyle(Color.secondary)
            
            if let dueAt = salesNote.dueAt {
                HStack(spacing: 6) {
                    Image(systemName: "clock")
                    
                    Text("Tagih \(dueAt.formatted(date: .long, time: .omitted))")
                }
                .font(.subheadline)
                .foregroundStyle(.orange)
            }
            Divider()

            HStack {
                Text("Lihat Detail")
                    .foregroundStyle(.blue)
                
                Spacer()
                
                Image(systemName: "chevron.right.circle")
                    .foregroundStyle(.blue)
            }
        }
    }
}

#Preview("DP Paid") {
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
        paidAmount: 10000,
        status: .dp,
        noteFileLink: nil,
        dueAt: Date(),
        soldAt: Date(),
        items: [
            SalesNoteItem(id: UUID(), salesNoteId: UUID(), name: "Keripik Tempe 100 g", quantity: 2, unitPrice: 15000, subtotal: 30000)
        ]
    )
   
    SalesCard(salesNote: dummyNote)
}
