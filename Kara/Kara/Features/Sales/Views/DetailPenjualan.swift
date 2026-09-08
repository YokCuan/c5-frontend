//
//  DetailPenjualan.swift
//  Kara
//
//  Created by Shelly Mutiara Haq on 27/08/26.
//

import SwiftUI

struct DetailPenjualan: View {
    
    @State private var salesNote: SalesNote
    let shop: Shop
    var onNoteUpdated: ((SalesNote) -> Void)?
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.displayScale) private var displayScale
    
    @State private var isShowingDeleteSheet = false
    @State private var showPaymentHistory = false
    @State private var renderedInvoiceImage: Image? = nil
    
    public init(salesNote: SalesNote, shop: Shop, onNoteUpdated: ((SalesNote) -> Void)? = nil) {
        self._salesNote = State(initialValue: salesNote)
        self.shop = shop
        self.onNoteUpdated = onNoteUpdated
    }
    
    private var isFullyPaid: Bool {
        salesNote.status == .paid
    }
    
    private var shouldShowPaymentHistory: Bool {
        guard let payments = salesNote.payments, !payments.isEmpty else { return false }
        if isFullyPaid && payments.count == 1 && payments.first?.paidAmount == salesNote.totalAmount {
            return false
        }
        return true
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Rectangle()
                        .fill(statusColor)
                        .frame(height: 4)
                        .accessibilityHidden(true)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(salesNote.customerName)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                Text("\(salesNote.soldAt.formatted(date: .long, time: .omitted)) • \(formatTime(salesNote.soldAt))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .accessibilityLabel("\(salesNote.soldAt.formatted(date: .long, time: .omitted)), pukul \(formatTime(salesNote.soldAt).replacingOccurrences(of: ".", with: ":"))")
                            }
                            
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
                                .accessibilityLabel("\(Int(salesNote.totalAmount)) rupiah")
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
                                .accessibilityLabel("\(Int(salesNote.paidAmount)) rupiah")
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
                            .accessibilityLabel("\(Int(salesNote.totalAmount - salesNote.paidAmount)) rupiah")
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
                        
                        if shouldShowPaymentHistory, let payments = salesNote.payments {
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 10) {
                                if showPaymentHistory {
                                    VStack(spacing: 16) {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("RIWAYAT CICILAN")
                                                .font(.caption2)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(.secondary)
                                            ForEach(Array(payments.enumerated()), id: \.element.id) { index, payment in
                                                HStack {
                                                    Text("\(index + 1). \(payment.paidAt.formatted(date: .long, time: .omitted))")
                                                        .font(.caption)
                                                    
                                                    Spacer()
                                                    Text("+\(formatRupiah(payment.paidAmount))")
                                                        .font(.caption.bold())
                                                    
                                                }
                                            }
                                        }
                                        Divider()
                                    }
                                }
                                Button {
                                    withAnimation(.snappy) {
                                        showPaymentHistory.toggle()
                                    }
                                } label: {
                                    HStack {
                                        Spacer()
                                        Text(showPaymentHistory ? "Sembunyikan" : "Lihat Riwayat")
                                            .font(.caption)
                                        Image(systemName: showPaymentHistory ? "chevron.up" : "chevron.down")
                                            .font(.caption2)
                                        Spacer()
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(16)
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
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
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel("\(item.name), \(item.quantity) jumlah barang, dengan harga satuan \(Int(item.unitPrice)) rupiah, total \(Int(item.subtotal)) rupiah")
                            
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
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 16)
                .padding(.top, 12)
                
                VStack(spacing: 12) {
                    NavigationLink {
                        InvoiceView(note: salesNote, shop: shop, onNoteUpdated: { updated in
                            self.salesNote = updated
                            self.onNoteUpdated?(updated)
                        })
                    } label: {
                        Text(isFullyPaid ? "Lihat Kwitansi" : "Lihat Nota")
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
                .padding(.bottom, 24)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
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
                    .accessibilityAddTraits(.isHeader)
            }
            ToolbarItem(placement: .topBarTrailing) {
                if let imageToShare = renderedInvoiceImage {
                    ShareLink(
                        item: imageToShare,
                        preview: SharePreview(isFullyPaid ? "Bagikan Kwitansi" : "Kirim Tagihan", image: imageToShare)
                    ) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .task {
            await renderInvoiceToImage()
        }
        .sheet(isPresented: $isShowingDeleteSheet) {
            DeleteIncome(
                salesNoteId: salesNote.id,
                shopId: salesNote.shopId,
                onDeleted: {
                    dismiss()
                }
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }
    
    @MainActor
    private func renderInvoiceToImage() async {
        let renderer = ImageRenderer(content: InvoiceComponent(note: salesNote, shop: shop))
        renderer.scale = displayScale
         
        if let uiImage = renderer.uiImage {
            renderedInvoiceImage = Image(uiImage: uiImage)
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

private func formatTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH.mm"
    return formatter.string(from: date)
}

#Preview {
    NavigationStack {
        DetailPenjualan(
            salesNote: PreviewFixtures.dpSalesNote,
            shop: AppMockData.primaryShop
        )
    }
}
