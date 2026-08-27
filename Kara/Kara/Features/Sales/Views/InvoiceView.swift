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
    
    // Computed Properties — taruh di atas body
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
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.blue)
                                .cornerRadius(24)
                        }
                    }
                    
                    if let imageToShare = renderedInvoiceImage {
                        ShareLink(
                            item: imageToShare,
                            preview: SharePreview(shareButtonLabel, image: imageToShare)   // <- ganti dari "Nota Pembayaran"
                        ) {
                            Text(shareButtonLabel)   // <- ganti dari Text("Bagikan Nota")
                                .font(.headline)
                                .foregroundColor(isFullyPaid ? .white : .black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
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
                Text(navigationTitleText)   // <- ganti ini
                    .font(.headline.bold())
                    .foregroundStyle(.white)
            }
        }
        .task {
            await renderInvoiceToImage()
        }
        .sheet(isPresented: $showCatatPembayaran) {
            SheetCatatPembayaran(
                customerName: note.customerName,
                remainingAmount: note.totalAmount - note.paidAmount
            )
            .presentationDetents([.height(400)])
            .presentationDragIndicator(.visible)
        }
    }
    // MARK: - Functions
    @MainActor
    private func renderInvoiceToImage() async {
        let renderer = ImageRenderer(content: InvoiceComponent(note: note, shop: shop))
        renderer.scale = displayScale
        
        if let uiImage = renderer.uiImage {
            renderedInvoiceImage = Image(uiImage: uiImage)
        }
    }
}

// MARK: - Preview Sample Data
extension Shop {
    static let sampleForPreview = Shop(
        ownerId: UUID(),
        name: "Keripik Bu Ria",
        description: "Usaha Keripik Tempe Sagu"
    )
}

extension SalesNote {
    static let sampleUnpaid = SalesNote(
        id: UUID(),
        shopId: UUID(),
        identifier: "8614",
        customerName: "Bu Sherin",
        customerPhone: "081234567890",
        totalAmount: 50000,
        paidAmount: 0,
        status: .notPaid,
        noteFileLink: nil,
        dueAt: Calendar.current.date(byAdding: .day, value: 30, to: Date()),
        soldAt: Date(),
        items: nil
    )
    
    static let samplePaid = SalesNote(
        id: UUID(),
        shopId: UUID(),
        identifier: "8615",
        customerName: "Bu Sherin",
        customerPhone: "081234567890",
        totalAmount: 50000,
        paidAmount: 50000,
        status: .paid,
        noteFileLink: nil,
        dueAt: nil,
        soldAt: Date(),
        items: nil
    )
}

// MARK: - Preview: Belum Lunas
#Preview("Belum Lunas") {
    NavigationStack {
        InvoiceView(note: .sampleUnpaid, shop: .sampleForPreview)
    }
}

// MARK: - Preview: Lunas
#Preview("Lunas") {
    NavigationStack {
        InvoiceView(note: .samplePaid, shop: .sampleForPreview)
    }
}
