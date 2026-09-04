//
//  InvoiceView.swift
//  Kara
//
//  Created by Samuel Bonardo on 26/08/26.
//

import SwiftUI

public struct InvoiceView: View {
    
    @State public var note: SalesNote
    public let shop: Shop
    public var onNoteUpdated: ((SalesNote) -> Void)?
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.displayScale) private var displayScale
    
    @State private var isShowingDeleteSheet = false
    @State private var showCatatPembayaran: Bool = false
    @State private var renderedInvoiceImage: Image? = nil
    @State private var isLoadingRefresh = false
    
    public init(note: SalesNote, shop: Shop, onNoteUpdated: ((SalesNote) -> Void)? = nil) {
            self._note = State(initialValue: note)
            self.shop = shop
            self.onNoteUpdated = onNoteUpdated
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
                    Task {
                        await fetchLatestNoteDetails()
                    }
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
    
    private func fetchLatestNoteDetails() async {
            do {
                let updatedNote = try await APIService.shared.fetchSalesNoteDetail(
                    id: note.id,
                    shopId: note.shopId
                )
                
                self.note = updatedNote
                
                onNoteUpdated?(updatedNote)
                
                await renderInvoiceToImage()
            } catch {
                print("Gagal memperbarui data invoice: \(error.localizedDescription)")
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
