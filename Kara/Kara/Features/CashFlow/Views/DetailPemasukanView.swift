//
//  DetailPemasukanView.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 23/08/26.
//

import SwiftUI

public struct DetailPemasukanView: View {
    
    let transaction: CashFlowModel
    
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingDelSheet = false
    
    public init(transaction: CashFlowModel) {
        self.transaction = transaction
    }
    
    public var body: some View {
        detailContent(transaction: transaction)
    }
    
    @ViewBuilder
    private func detailContent(transaction: CashFlowModel) -> some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 0) {
                Rectangle()
                    .fill(Color.green)
                    .frame(height: 4)
                    .accessibilityHidden(true)
                 
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack{
                            Text(transaction.title)
                                .font(.title2.bold())
                            Spacer()
                            Text(transaction.description != nil ? "#\(transaction.description!)" : "-")
                                .font(.footnote)
                                .padding(4)
                                .padding(.horizontal, 4)
                                .foregroundStyle(.blue)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(16)
                                .accessibilityLabel(transaction.description != nil ? "ID Transaksi: \(transaction.description!)" : "ID Transaksi Kosong")
                        }
                        Text("Penjualan")
                            .foregroundStyle(.secondary)
                    }
                     
                    VStack(alignment: .leading, spacing: 5) {
                        Text("JUMLAH DITERIMA")
                            .font(.caption2.bold())
                            .foregroundStyle(.gray)
                        Text("+ \(transaction.amount.toIDR)")
                            .font(.title.bold())
                            .foregroundStyle(.green)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Jumlah Diterima, \(Int(transaction.amount)) rupiah")
                     
                    Divider()
                     
                    VStack(spacing: 8) {
                        HStack {
                            Text("Waktu")
                                .foregroundStyle(.gray)
                            Spacer()
                            Text(transaction.occurredAt.formattedTime())
                                .bold()
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Waktu, \(transaction.occurredAt.formattedTime().replacingOccurrences(of: ".", with: ":"))")
                        HStack {
                            Text("Tanggal")
                                .foregroundStyle(.gray)
                            Spacer()
                            Text(transaction.occurredAt.formattedDate())
                                .bold()
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Tanggal, \(transaction.occurredAt.formattedDate().replacingOccurrences(of: ".", with: " "))")
                    }
                }
                .padding()
            }
            .background(.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 5, y: 4)
             
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.circle")
                Text("Uang Masuk dari penjualan tidak bisa diedit.")
                Spacer()
            }
            .font(.footnote)
            .foregroundStyle(.blue)
            .padding(15)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(14)
            .accessibilityElement(children: .combine)
             
//            Button(action: { isShowingDelSheet = true }) {
//                Text("Hapus Pemasukan")
//                    .font(.title3.bold())
//                    .foregroundStyle(.red)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(.gray.opacity(0.15))
//                    .cornerRadius(48)
//            }
//            .sheet(isPresented: $isShowingDelSheet) {
//                DeleteIncome(
//                    salesNoteId: transaction.id,
//                    shopId: AppMockData.primaryShop.id,
//                    onDeleted: {
//                        dismiss()
//                    }
//                )
//                .presentationDetents([.fraction(0.5)])
//                .presentationDragIndicator(.visible)
//            }
             
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
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
                Text("Detail Uang Masuk")
                    .font(.headline.bold())
                    .foregroundStyle(.white)
                    .accessibilityAddTraits(.isHeader)
            }
        }
    }
}
    
//    @MainActor
//    private func fetchSalesNoteDetail() async {
//        isLoading = true
//        errorMessage = nil
//        
//        do {
//            self.note = try await APIService.shared
//                .fetchSalesNoteDetail(
//                    id: salesNoteID,
//                    shopId: AppMockData.primaryShop.id
//                )
//            self.isLoading = false
//        } catch {
//            self.errorMessage = "Gagal memuat detail penjualan: \(error.localizedDescription)"
//            self.isLoading = false
//        }
//    }
//}

#Preview {
    NavigationStack {
        DetailPemasukanView(
            transaction: CashFlowModel(
                id: UUID(),
                amount: 30000,
                occurredAt: Date(),
                type: .salesNote,
                categoryType: "Penjualan",
                title: "Bu Ria",
                description: "00001 - Pembayaran ke 2"
            )
        )
    }
}
