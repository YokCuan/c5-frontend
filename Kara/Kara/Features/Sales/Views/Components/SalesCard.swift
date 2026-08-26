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
    SalesCard(salesNote: AppMockData.salesNotes[1])
}
