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
    @State private var searchText: String = ""
    @State private var selectedDateRange: FilterComponent.DateRange? = nil
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var isShowingFilterSheet = false
    @State private var scrollOffset: CGFloat = 0
    
    private var isAnyFilterActive: Bool {
        selectedStatus != nil
        || !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || selectedDateRange != nil
    }
    
    private var activeFilterSummary: String? {
        var parts: [String] = []
        
        if let selectedStatus {
            parts.append(selectedStatus.title)
        }
        
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !query.isEmpty {
            parts.append("Cari: \(query)")
        }
        
        if let selectedDateRange {
            switch selectedDateRange {
            case .last7Days, .thisMonth:
                parts.append(selectedDateRange.rawValue)
            case .custom:
                parts.append("Tanggal: \(startDate.formatted(date: .abbreviated, time: .omitted)) - \(endDate.formatted(date: .abbreviated, time: .omitted))")
            }
        }
        
        return parts.isEmpty ? nil : parts.joined(separator: " • ")
    }
    
    private var filteredNotes: [SalesNote] {
        AppMockData.salesNotes.filter { note in
            let matchesStatus = selectedStatus == nil || note.status == selectedStatus
            let matchesDateRange = matchesDateRange(for: note.soldAt)
            let searchableText = [
                note.customerName,
                note.identifier,
                note.customerPhone,
                note.items?.map { $0.name }.joined(separator: " ")
            ]
                .compactMap { $0 }
                .joined(separator: " ")
                .lowercased()
            
            let matchesSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || searchableText.contains(searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())
            
            return matchesStatus && matchesDateRange && matchesSearch
        }
    }
    
    var body: some View {
        NavigationStack {
            let isScrolled = scrollOffset > 30
            VStack(alignment: .leading, spacing: 0) {
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Penjualan")
                        .font(isScrolled ? .title2 : .largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .animation(.easeOut(duration: 0.2), value: isScrolled)
                    HStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(Color.white.opacity(0.8))
                            
                            TextField(
                                "",
                                text: $searchText,
                                prompt: Text("Cari pembeli atau nota...")
                                    .foregroundColor(Color.white.opacity(0.8))
                            )
                            .font(.body)
                        }
                        .padding(.horizontal, 14)
                        .frame(height: 42)
                        .background(Color.white.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Button {
                            isShowingFilterSheet = true
                        } label: {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "line.3.horizontal.decrease")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(Color.white.opacity(0.8))
                                    .frame(width: 42, height: 42)
                                    .background(isAnyFilterActive ? Color.white.opacity(0.12) : Color.white.opacity(0.12))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                if isAnyFilterActive {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 10, height: 10)
                                        .offset(x: 2, y: -2)
                                }
                            }
                        }
                    }
                    
                    HStack {
                        filterButton("Semua", status: nil)
                        Spacer()
                        filterButton("Belum Bayar", status: .notPaid)
                        Spacer()
                        filterButton("DP", status: .dp)
                        Spacer()
                        filterButton("Lunas", status: .paid)
                    }
                    
                    if let activeFilterSummary {
                        Text(activeFilterSummary)
                            .font(.footnote)
                            .foregroundStyle(.white.opacity(0.8))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding(.horizontal)
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
                                selectedNote = note
                            })
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                }
                .background(Color(.systemGray6))
                .onScrollGeometryChange(for: CGFloat.self) { geometry in
                    geometry.contentOffset.y
                } action: { _, newValue in
                    scrollOffset = newValue
                }
                .toolbar(.hidden, for: .navigationBar)
                .navigationDestination(item: $selectedNote) { note in
                    DetailPenjualan(
                        salesNote: note,
                        shop: AppMockData.primaryShop
                    )
                }
                .sheet(isPresented: $isShowingFilter) {
                    FilterComponent(
                        selectedDateRange: $selectedDateRange,
                        startDate: $startDate,
                        endDate: $endDate
                    )
                }
                //            .navigationDestination(item: $selectedNote) { note in
                //                DetailPenjualan(
                //                    salesNote: note,
                //                    shop: AppMockData.primaryShop
                //                )
                //            }
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
                    .font(.footnote)
                    .foregroundStyle(
                        selectedStatus == status
                        ? .black
                        : .white.opacity(0.8)
                    )
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        selectedStatus == status
                        ? Color.white
                        : Color.white.opacity(0.08)
                    )
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .clipShape(Capsule())
            }
        }
        
        private func matchesDateRange(for soldAt: Date) -> Bool {
            guard let selectedDateRange else {
                return true
            }
            
            let calendar = Calendar.current
            let noteDay = calendar.startOfDay(for: soldAt)
            
            switch selectedDateRange {
            case .last7Days:
                let start = calendar.startOfDay(for: calendar.date(byAdding: .day, value: -6, to: Date()) ?? Date())
                let end = calendar.startOfDay(for: Date())
                return noteDay >= start && noteDay <= end
            case .thisMonth:
                let start = monthStartDate(for: Date())
                let end = monthEndDate(for: Date())
                return noteDay >= start && noteDay <= end
            case .custom:
                let lowerBound = calendar.startOfDay(for: min(startDate, endDate))
                let upperBound = calendar.startOfDay(for: max(startDate, endDate))
                return noteDay >= lowerBound && noteDay <= upperBound
            }
        }
        
        private func monthStartDate(for date: Date) -> Date {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: date)
            return calendar.date(from: components) ?? date
        }
        
        private func monthEndDate(for date: Date) -> Date {
            let calendar = Calendar.current
            guard
                let nextMonth = calendar.date(byAdding: .month, value: 1, to: monthStartDate(for: date)),
                let end = calendar.date(byAdding: .day, value: -1, to: nextMonth)
            else {
                return date
            }
            return end
        }
    }
    
    #Preview {
        NavigationStack {
            Penjualan()
        }
    }
