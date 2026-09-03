//
//  SalesCard.swift
//  Kara
//
//  Created by Shelly Mutiara Haq on 24/08/26.
//


import SwiftUI

struct SalesCard: View {
    let salesNote: SalesNote
    let onTapDetail: () -> Void

    private var remainingAmount: Double {
            max(0, salesNote.totalAmount - salesNote.paidAmount)
        }
    var body: some View {
        Button(action: onTapDetail) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                Text (salesNote.customerName)
                    .font(.headline)
                Spacer()
                Text (salesNote.status.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(salesNote.status.themeColor)
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
            
//            Divider ()
            
            if salesNote.status == .dp || salesNote.status == .notPaid {
                
                Divider()
                HStack {
                    Text("Sisa Pembayaran")
                    Spacer()
                    Text(remainingAmount.toIDR)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                }
                .foregroundStyle(.secondary)
                
                if let dueAt = salesNote.dueAt {
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                        Text("Tagih \(dueAt.formatted(date: .long, time: .omitted))")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.orange)
                }
            }
            Divider()
            Text("Lihat Detail")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.blue)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
        )
        .overlay(alignment: .top) {
            Rectangle()
                .fill(salesNote.status.themeColor)
                .frame(height: 2)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
        .shadow(
//              color: .black.opacity(0.08),
            color: salesNote.status.themeColor.opacity(0.1),
            radius: 8,
            x: 0,
            y: 3
        )
        }
        .buttonStyle(.plain)
    }
}

#Preview("DP Paid") {
    SalesCard(
        salesNote: PreviewFixtures.dpSalesNote,
        onTapDetail: {}
    )
}
