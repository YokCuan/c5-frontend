//
//  InvoiceView.swift
//  Kara
//
//  Created by Samuel Bonardo on 26/08/26.
//

import SwiftUI

public struct InvoiceView: View {
    
    public let note: SalesNote
    public let shop: Shop
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.displayScale) private var displayScale
    
    @State private var isShowingDeleteSheet = false
    @State private var showCatatPembayaran: Bool = false
    @State private var renderedInvoiceImage: Image? = nil
    
    public init(note: SalesNote, shop: Shop) {
        self.note = note
        self.shop = shop
    }
    
    private var isFullyPaid: Bool {
        note.status == .paid
    }
    
    private var navigationTitleText: String {
        isFullyPaid ? "Kwitansi" : "Tagihan"
    }
    
    private var shareButtonLabel: String {
        isFullyPaid ? "Bagikan Kwitansi" : "Kirim Tagihan"
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                InvoiceComponent(note: note, shop: shop)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                
                VStack{
                    if !isFullyPaid {
                        Button {
                            self.showCatatPembayaran = true
                        } label: {
                            Text("Catat Pembayaran")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.blue)
                                .clipShape(Capsule())
                        }
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
            }
            .padding(.horizontal)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
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
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .padding(8)
                }
            }
            ToolbarItem(placement: .principal) {
                Text(navigationTitleText)
                    .font(.headline.bold())
                    .foregroundStyle(.white)
            }
            ToolbarItem(placement: .topBarTrailing){
                if let imageToShare = renderedInvoiceImage {
                    ShareLink(
                        item: imageToShare,
                        preview: SharePreview(shareButtonLabel, image: imageToShare)
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
                    salesNoteId: note.id,
                    shopId: note.shopId,
                    onDeleted: {
                        dismiss()
                    }
                )
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showCatatPembayaran) {
            SheetCatatPembayaran(
                salesNoteId: note.id,
                        shopId: note.shopId,
                        userId: AppMockData.currentUser.id,
                        customerName: note.customerName,
                        remainingAmount: note.totalAmount - note.paidAmount,
                onSuccess: {
                    dismiss()
                }
            )
            .presentationDetents([.height(350)])
            .presentationDragIndicator(.visible)
            .background(Color(.systemBackground))
        }
    }
    @MainActor
    private func renderInvoiceToImage() async {
        let renderer = ImageRenderer(content: InvoiceComponent(note: note, shop: shop))
        renderer.scale = displayScale
        
        if let uiImage = renderer.uiImage {
            renderedInvoiceImage = Image(uiImage: uiImage)
        }
    }
}

#Preview("Belum Lunas") {
    NavigationStack {
        InvoiceView(
            note: PreviewFixtures.notPaidSalesNote,
            shop: AppMockData.primaryShop
        )
    }
}

#Preview("Lunas") {
    NavigationStack {
        InvoiceView(
            note: PreviewFixtures.paidSalesNote,
            shop: AppMockData.primaryShop
        )
    }
}
