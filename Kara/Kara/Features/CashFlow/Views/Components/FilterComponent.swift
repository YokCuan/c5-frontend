//
//  FilterComponent.swift
//  Kara
//
//  Created by Shelly Mutiara Haq on 26/08/26.
//

import SwiftUI

struct FilterComponent: View {
    
    enum DateRange: String, CaseIterable {
        case last7Days = "7 hari terakhir"
        case thisMonth = "Bulan Ini"
        case custom = "Atur rentang tanggal"
    }
    
    @State private var selectedDateRange: DateRange? = nil
    @State private var isShowingDatePicker = false
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    var body: some View {
        VStack(spacing: 16) {
            
            // MARK: - Header
            HStack {
                Text("Filter Transaksi")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Button {
                    // Nanti untuk reset filter
                } label: {
                    Text("Pulihkan")
                        .font(.subheadline)
                        .underline()
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.top)
            .padding(.bottom)
            
            
            // MARK: - Rentang Waktu
            VStack(alignment: .leading, spacing: 16) {
                
                Text("Rentang waktu")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
//                    .padding(.horizontal)
                    .padding(.top)
                
                ForEach(DateRange.allCases, id: \.self) { range in
                    
                    Button {
                        selectedDateRange = range
                        
                        if range == .custom {
                            isShowingDatePicker = true
                        }
                    } label: {
                        HStack(spacing: 16) {
                            
                            Text(range.rawValue)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                            
                            Spacer()
                            
                            Image(
                                systemName: selectedDateRange == range
                                ? "largecircle.fill.circle"
                                : "circle"
                            )
                            .font(.title2)
                            .foregroundStyle(
                                selectedDateRange == range
                                ? .blue
                                : .secondary
                            )
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        
        // MARK: - Date Range Sheet
        .sheet(isPresented: $isShowingDatePicker) {
            SheetDatePicker(
                startDate: $startDate,
                endDate: $endDate,
                parentSheetDismiss: {
                    isShowingDatePicker = false
                }
            )
            .presentationDetents([.fraction(0.6), .height(.infinity)])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    FilterComponent()
}
