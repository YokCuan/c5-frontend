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
    
    @Binding var selectedDateRange: DateRange?
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    @State private var isShowingDatePicker = false
    @Environment(\.dismiss) private var dismiss
    
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
                    resetFilter()
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
                        selectRange(range)
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
            
            Button {
                applyFilter()
                dismiss()
            } label: {
                Text("Terapkan Filter")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
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
    
    private func resetFilter() {
        selectedDateRange = nil
        let today = Date()
        startDate = today
        endDate = today
    }
    
    private func applyFilter() {
        dismiss()
    }
    
    private func selectRange(_ range: DateRange) {
        selectedDateRange = range
        
        let calendar = Calendar.current
        let today = Date()
        
        switch range {
        case .last7Days:
            startDate = calendar.date(byAdding: .day, value: -6, to: today) ?? today
            endDate = today
        case .thisMonth:
            startDate = monthStartDate(for: today)
            endDate = monthEndDate(for: today)
        case .custom:
            isShowingDatePicker = true
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
    FilterComponent(
        selectedDateRange: .constant(nil),
        startDate: .constant(Date()),
        endDate: .constant(Date())
    )
}
