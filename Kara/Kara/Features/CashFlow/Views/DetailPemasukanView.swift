//
//  DetailPemasukanView.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 23/08/26.
//

import SwiftUI

public struct DetailPemasukanView: View {
    
    let salesNoteID: UUID
    
    @State private var note: SalesNote? = nil
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingDelSheet = false
    
    public init(salesNoteId: UUID) {
        self.salesNoteID = salesNoteId
    }
    
    public init(note: SalesNote) {
        self.salesNoteID = note.id
        self._note = State(initialValue: note)
        self._isLoading = State(initialValue: false)
    }
    
    public var body: some View {
        Group {
            if isLoading {
                ProgressView("Memuat data penjualan...")
            } else if let errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.orange)
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            } else if let note {
                detailContent(note: note)
            }
        }
        .task {
            if note == nil {
                await fetchSalesNoteDetail()
            }
        }
    }
    
    @ViewBuilder
    private func detailContent(note: SalesNote) -> some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 0) {
                Rectangle()
                    .fill(Color.green)
                    .frame(height: 4)
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(note.customerName)
                            .font(.title2.bold())
                        Text("Penjualan · \(note.identifier)")
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("JUMLAH DITERIMA")
                            .font(.caption2.bold())
                            .foregroundStyle(.gray)
                        Text("+ \(note.paidAmount.toIDR)")
                            .font(.title.bold())
                            .foregroundStyle(.green)
                    }
                    
                    Divider()
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("Waktu")
                                .foregroundStyle(.gray)
                            Spacer()
                            Text(note.soldAt.formattedTime())
                                .bold()
                        }
                        HStack {
                            Text("Tanggal")
                                .foregroundStyle(.gray)
                            Spacer()
                            Text(note.soldAt.formattedDate())
                                .bold()
                        }
                    }
                }
                .padding()
            }
            .background(.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 5, y: 4)
            
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.circle")
                Text("Pemasukan dari penjualan tidak bisa diedit. Ubah data di halaman Penjualan")
                Spacer()
            }
            .font(.footnote)
            .foregroundStyle(.blue)
            .padding(15)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            
            Button(action: { isShowingDelSheet = true }) {
                Text("Hapus Pemasukan")
                    .font(.title3.bold())
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.gray.opacity(0.15))
                    .cornerRadius(48)
            }
            .sheet(isPresented: $isShowingDelSheet) {
                DeleteIncome(
                        salesNoteId: note.id,
                        shopId: note.shopId,
                        onDeleted: {
                            dismiss()
                        }
                    )
                    .presentationDetents([.fraction(0.5)])
                    .presentationDragIndicator(.visible)
            }
            
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
                Text("Detail Pemasukan")
                    .font(.headline.bold())
                    .foregroundStyle(.white)
            }
        }
    }
    
    @MainActor
    private func fetchSalesNoteDetail() async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.note = try await APIService.shared
                .fetchSalesNoteDetail(
                    id: salesNoteID,
                    shopId: AppMockData.primaryShop.id
                )
            self.isLoading = false
        } catch {
            self.errorMessage = "Gagal memuat detail penjualan: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
}

#Preview {
    NavigationStack {
        DetailPemasukanView(note: PreviewFixtures.dpSalesNote)
    }
}
