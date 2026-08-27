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
    @State private var isShowingInvoice = false
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundStyle(.black)
                            .frame(width: 40, height: 40)
                            .background(.white.opacity(0.4))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .overlay {
                    Text("Detail Penjualan")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.karaBlueDark, .karaBlue]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    //                .ignoresSafeArea(edges: .top)
                )
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
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Keripik Tempe 100 g")
                                .font(.body)
                            
                            Text("2 pcs · Rp10.000 / pcs")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("Rp20.000")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    
                    Divider()
                        .padding(.vertical, 16)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Keripik Tempe 100 g")
                                .font(.body)
                            
                            Text("2 pcs · Rp10.000 / pcs")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("Rp20.000")
                            .font(.subheadline)
                            .fontWeight(.bold)
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
                    
                    Button {
                        isShowingInvoice = true
                    } label: {
                        Text("Lihat Nota")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(.blue)
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
        .sheet(isPresented: $isShowingDeleteSheet) {
            DeleteIncome()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isShowingInvoice) {
            InvoiceView(
                note: salesNote,
                shop: shop
            )
        }
//        .ignoresSafeArea(edges: .top)
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
    DetailPenjualan(
        salesNote: SalesNote(
            id: UUID(),
            shopId: UUID(),
            identifier: "#8612",
            customerName: "Bu Sherin",
            customerPhone: "08123456789",
            totalAmount: 50000,
            paidAmount: 45000,
            status: .dp,
            noteFileLink: nil,
            dueAt: Date(),
            soldAt: Date(),
            items: nil
        ),
        shop: Shop(
                    ownerId: UUID(),
                    name: "Keripik Bu Ria",
                    description: "Usaha Keripik Tempe Sagu"
                )
    )
}
