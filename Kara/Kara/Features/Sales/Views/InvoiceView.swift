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
                
                VStack(spacing: 16) {
                    if !isFullyPaid {
                        Button {
                            self.showCatatPembayaran = true
                        } label: {
                            Text("Catat Pembayaran")
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(24)
                        }
                    }
                    
                    if let imageToShare = renderedInvoiceImage {
                        ShareLink(
                            item: imageToShare,
                            preview: SharePreview(shareButtonLabel, image: imageToShare)
                        ) {
                            Text(shareButtonLabel)
                                .font(.title3.bold())
                                .foregroundColor(isFullyPaid ? .white : .black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isFullyPaid ? Color.blue : Color(.systemGray5))
                                .cornerRadius(24)
                        }
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
        }
        .task {
            await renderInvoiceToImage()
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
            .presentationDetents([.height(400)])
            .presentationDragIndicator(.visible)
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
