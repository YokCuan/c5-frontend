//
//  InvoiceDocumentView.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 24/08/26.
//

import SwiftUI

public struct InvoiceComponent: View {
    let note: SalesNote
    var shop: Shop
    
    private var remainingAmount: Double {
        max(0, note.totalAmount - note.paidAmount)
    }
    
    public var body: some View {
        ZStack {
            if let watermark = note.status.watermarkText {
                Text(watermark)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundStyle(note.status.themeColor.opacity(0.07))
                    .multilineTextAlignment(.center)
                    .rotationEffect(.degrees(-25))
            }
            
            VStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text(shop.name)
                        .textCase(.uppercase)
                        .font(.title2.bold())
                    if let description = shop.description {
                        Text(description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Nota \(note.identifier)")
                            .font(.footnote)
                            .bold()
                        Spacer()
                        Text(note.soldAt.formattedDate())
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    VStack(alignment: .leading, spacing: 2){
                        HStack {
                            Text("Pembeli:")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(note.customerName)
                                .font(.subheadline)
                                .bold()
                        }
                        Text(note.customerPhone ?? "-")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("RINCIAN BARANG")
                        .font(.caption2.bold())
                        .foregroundStyle(.secondary)
                    
                    if let items = note.items, !items.isEmpty {
                        ForEach(items) { item in
                            HStack(alignment: .center) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name)
                                        .font(.body)
                                    Text("\(item.quantity) pcs × \(item.unitPrice.toIDR) / pcs")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(item.subtotal.toIDR)
                                    .font(.body.bold())
                            }
                        }
                    } else {
                        Text("Tidak ada rincian barang")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Divider()
                
                VStack(spacing: 8) {
                    HStack {
                        Text("Total")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(note.totalAmount.toIDR)
                            .bold()
                    }
                    HStack {
                        Text("Sudah dibayar")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(note.paidAmount.toIDR)
                            .foregroundStyle(.green)
                            .bold()
                    }
                    
                    if note.status != .paid{
                        HStack {
                            Text("Sisa pembayaran")
                                .bold()
                                .foregroundStyle(note.status == .paid ? .primary : note.status.themeColor)
                            Spacer()
                            Text(remainingAmount.toIDR)
                                .bold()
                                .foregroundStyle(
                                    note.status == .paid ? .primary : note.status.themeColor
                                )
                        }
                        
                        if note.status != .paid, let dueDate = note.dueAt {
                            HStack {
                                Spacer()
                                Text("Tagih pada: \(dueDate.formattedDate())")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                
                HStack(spacing: 12) {
                    Image(systemName: note.status.iconName)
                        .font(.title2.bold())
                        .foregroundStyle(note.status.themeColor)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(note.status.title)
                            .font(.body.bold())
                            .foregroundStyle(note.status.themeColor)
                        
                        if note.status == .paid {
                            Text("Pembayaran telah selesai")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        } else if let dueDate = note.dueAt {
                            Text("Tagih pada: \(dueDate.formattedDate())")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                }
                .padding(12)
                .background(note.status.themeColor.opacity(0.08))
             
                
                Text("Terima kasih telah berbelanja di \(shop.name).")
                    .font(.caption2.italic())
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
            .padding()
        }
        .background(Color.white)
    }
}

#Preview("Not Paid") {
    let dummyShop = AppMockData.primaryShop
    let dummyNote = PreviewFixtures.notPaidSalesNote

    ZStack {
        Color(.systemGroupedBackground).ignoresSafeArea()
        InvoiceComponent(note: dummyNote, shop: dummyShop)
            .padding(20)
    }
}

#Preview("DP Paid") {
    let dummyShop = AppMockData.primaryShop
    let dummyNote = PreviewFixtures.dpSalesNote

    ZStack {
        Color(.systemGroupedBackground).ignoresSafeArea()
        InvoiceComponent(note: dummyNote, shop: dummyShop)
            .padding(20)
    }
}
