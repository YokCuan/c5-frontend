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
    
    private let dummyNotes: [SalesNote] = [
        SalesNote(
            id: UUID(),
            shopId: UUID(),
            identifier: "#8612",
            customerName: "Bu Sherin",
            customerPhone: "08123456789",
            totalAmount: 50000,
            paidAmount: 45000,
            status: .paid,
            noteFileLink: nil,
            dueAt: nil,
            soldAt: Date(),
            items: nil
        ),

        SalesNote(
            id: UUID(),
            shopId: UUID(),
            identifier: "#8613",
            customerName: "Bu Ria",
            customerPhone: "08123456789",
            totalAmount: 100000,
            paidAmount: 50000,
            status: .dp,
            noteFileLink: nil,
            dueAt: Date(),
            soldAt: Date(),
            items: nil
        ),

        SalesNote(
            id: UUID(),
            shopId: UUID(),
            identifier: "#8614",
            customerName: "Budi",
            customerPhone: "08123456789",
            totalAmount: 150000,
            paidAmount: 100000,
            status: .notPaid,
            noteFileLink: nil,
            dueAt: Date(),
            soldAt: Date(),
            items: nil
        ),

        SalesNote(
            id: UUID(),
            shopId: UUID(),
            identifier: "#8615",
            customerName: "Bu Jess",
            customerPhone: "08123456789",
            totalAmount: 75000,
            paidAmount: 25000,
            status: .dp,
            noteFileLink: nil,
            dueAt: Date(),
            soldAt: Date(),
            items: nil
        ),
        
        SalesNote(
            id: UUID(),
            shopId: UUID(),
            identifier: "#8616",
            customerName: "Pak Andi",
            customerPhone: "08123456789",
            totalAmount: 200000,
            paidAmount: 150000,
            status: .dp,
            noteFileLink: nil,
            dueAt: Date(),
            soldAt: Date(),
            items: nil
        )
    ]
    
    private var filteredNotes: [SalesNote] {
            guard let selectedStatus else {
                return dummyNotes
            }
            return dummyNotes.filter {
                $0.status == selectedStatus
            }

        }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            // MARK: - Header
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Penjualan")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                // Search + Filter icon
                HStack(spacing: 16) {
                    
                    HStack {
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
                
                // Filter buttons
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
            
            // MARK: - Sales List
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredNotes) { note in
                        SalesCard(salesNote: note)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 16)
            }
            .background(Color(.systemGray6))
            
        }
        .sheet(isPresented: $isShowingFilter) {
            
            FilterComponent()
            //        .ignoresSafeArea(edges: .top)
        }
    }
    // MARK: - Filter Button
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
            //            .frame(maxWidth: .infinity)
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
