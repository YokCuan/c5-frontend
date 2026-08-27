//
//  Penjualan.swift
//  Kara
//
//  Created by Shelly Mutiara Haq on 26/08/26.
//

import SwiftUI

struct Penjualan: View {
    
    @State private var selectedStatus: PaymentStatus? = nil
    @State private var isShowingFilter = false
    @State private var selectedNote: SalesNote? = nil
    
    private var filteredNotes: [SalesNote] {
        guard let selectedStatus else {
            return AppMockData.salesNotes
        }
        return AppMockData.salesNotes.filter {
            $0.status == selectedStatus
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Penjualan")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 16) {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.white.opacity(0.5))
                            Text("Cari pembeli atau nota...")
                                .foregroundStyle(.white.opacity(0.5))
                                .lineLimit(1)
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.1))
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 10,
                                style: .continuous
                            )
                        )
                        
                        Button {
                            isShowingFilter = true
                        } label: {
                            Image(systemName: "calendar")
                                .foregroundStyle(.black)
                                .frame(width: 40, height: 40)
                                .background(.white)
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 10,
                                        style: .continuous
                                    )
                                )
                        }
                    }
                    
                    HStack(spacing: 9) {
                        filterButton("Semua", status: nil)
                        filterButton("Belum Bayar", status: .notPaid)
                        filterButton("DP", status: .dp)
                        filterButton("Lunas", status: .paid)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 16)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.karaBlueDark, .karaBlue]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .top)
                )
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredNotes) { note in
                            SalesCard(salesNote: note, onTapDetail: {
                                
                            })
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                }
                .background(Color(.systemGray6))
            }
            .navigationDestination(item: $selectedNote) { note in
                InvoiceView(note: note, shop: AppMockData.primaryShop)
            }
            .sheet(isPresented: $isShowingFilter) {
                FilterComponent()
            }
        }
    }
    
    private func filterButton(
        _ title: String,
        status: PaymentStatus?
    ) -> some View {
        Button {
            selectedStatus = status
        } label: {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(
                    selectedStatus == status
                    ? .black
                    : .white.opacity(0.8)
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 7)
                .background(
                    selectedStatus == status
                    ? Color.white
                    : Color.white.opacity(0.08)
                )
                .clipShape(Capsule())
        }
    }
}

#Preview {
    Penjualan()
}
