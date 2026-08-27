//
//  DetailPenjualan.swift
//  Kara
//
//  Created by Shelly Mutiara Haq on 27/08/26.
//

import SwiftUI

struct DetailPenjualan: View {
    
    let salesNote: SalesNote
    let shop: Shop
    
    @State private var isShowingDeleteSheet = false
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    HStack {
                        Text(salesNote.customerName)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text(statusText)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(statusColor)
                            .clipShape(Capsule())
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("TOTAL")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        
                        Text(formatRupiah(salesNote.totalAmount))
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("SUDAH DIBAYAR")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        
                        Text(formatRupiah(salesNote.paidAmount))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("SISA PEMBAYARAN")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        
                        Text(
                            formatRupiah(
                                salesNote.totalAmount - salesNote.paidAmount
                            )
                        )
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("TAGIH PADA")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        
                        Text(
                            salesNote.dueAt?.formatted(
                                date: .long,
                                time: .omitted
                            ) ?? "-"
                        )
                        .font(.body)
                    }
                }
                .padding(16)
                .background(.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 20)
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("BARANG")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 20)
                    
                    if let items = salesNote.items, !items.isEmpty {
                        ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name)
                                        .font(.body)
                                    
                                    Text("\(item.quantity) pcs · \(formatRupiah(item.unitPrice)) / pcs")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Text(formatRupiah(item.subtotal))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }
                            
                            if index < items.count - 1 {
                                Divider()
                                    .padding(.vertical, 16)
                            }
                        }
                    } else {
                        Text("Tidak ada rincian barang")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(16)
                .background(.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 20)
                )
                .padding(.horizontal, 16)
                .padding(.top, 12)
                
                    VStack(spacing: 12) {
                        
                    NavigationLink {
                        InvoiceView(note: salesNote, shop: shop)
                    } label: {
                        Text(
                            salesNote.status == .paid ? "Lihat Kwitansi": "Lihat Nota"
                        )
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.blue)
                            .clipShape(Capsule())
                    }
                    
                    Button {
                        isShowingDeleteSheet = true
                    } label: {
                        Text("Hapus Penjualan")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(.systemGray5))
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(
            LinearGradient(
                colors: [Color.karaBlueDark, Color.karaBlue],
                startPoint: .top,
                endPoint: .bottom
            ),
            for: .navigationBar
        )
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Detail Penjualan")
                    .font(.headline.bold())
                    .foregroundStyle(.white)
            }
        }
        .sheet(isPresented: $isShowingDeleteSheet) {
            DeleteIncome()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
    
    private var statusText: String {
        switch salesNote.status {
        case .paid:
            return "LUNAS"
        case .dp:
            return "DP"
        case .notPaid:
            return "BELUM DIBAYAR"
        }
    }
    
    private var statusColor: Color {
        switch salesNote.status {
        case .paid:
            return .green
        case .dp:
            return .orange
        case .notPaid:
            return .red
        }
    }
}

private func formatRupiah(_ amount: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencySymbol = "Rp"
    formatter.maximumFractionDigits = 0
    formatter.minimumFractionDigits = 0
    
    return formatter.string(
        from: NSNumber(value: amount)
    ) ?? "Rp0"
}

#Preview {
    NavigationStack {
        DetailPenjualan(
            salesNote: AppMockData.salesNotes[0],
            shop: AppMockData.primaryShop
        )
    }
}
