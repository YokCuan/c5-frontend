//
//  SearchBarFilterButton.swift
//  Kara
//
//  Created by Samuel Bonardo on 24/08/26.
//

import SwiftUI

struct SearchBarFilterButton: View {
    @ObservedObject var viewModel: CashFlowViewModel
    
    @Binding var searchText: String
    @Binding var selectedPaymentStatus: PaymentStatus?
    @Binding var selectedCategory: CategoryFilterOption?
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var useCustomDateRange: Bool
    @Binding var minAmountFilter: String
    @Binding var maxAmountFilter: String
    
    @State private var isShowingFilterSheet = false
    @State private var isShowingDatePickerSheet = false
    
    private var isAnyFilterActive: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || selectedPaymentStatus != nil
        || selectedCategory != nil
        || useCustomDateRange
        || !minAmountFilter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || !maxAmountFilter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var activeFilterSummary: String? {
        var parts: [String] = []
        
        if let selectedPaymentStatus {
            parts.append(selectedPaymentStatus.title)
        }
        
        if let selectedCategory {
            parts.append(selectedCategory.title)
        }
        
        if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            parts.append("Cari: \(searchText.trimmingCharacters(in: .whitespacesAndNewlines))")
        }
                
        return parts.isEmpty ? nil : parts.joined(separator: " • ")
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.8))
                    
                    TextField(
                        "",
                        text: $searchText,
                        prompt: Text("Cari transaksi...")
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
                Button {
                    viewModel.previousMonth()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.8))
                        .frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Spacer()
                
                Button {
                    isShowingDatePickerSheet = true
                } label: {
                    Text(viewModel.selectedMonthYearString)
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                Button {
                    viewModel.nextMonth()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.8))
                        .frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            
            if let activeFilterSummary {
                Text(activeFilterSummary)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.white.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }

        //summoning filter roll-up sheet
        .sheet(isPresented: $isShowingFilterSheet) {
            FilterSheetView(
                selectedPaymentStatus: $selectedPaymentStatus,
                selectedCategory: $selectedCategory,
                startDate: $startDate,
                endDate: $endDate,
                useCustomDateRange: $useCustomDateRange,
                minAmountFilter: $minAmountFilter,
                maxAmountFilter: $maxAmountFilter,
                viewModel: viewModel
            )
            .presentationDetents([.fraction(0.7), .large])
            .presentationDragIndicator(.visible)
        }

        .sheet(isPresented: $isShowingDatePickerSheet) {
            SheetDatePicker(
                startDate: $startDate,
                endDate: $endDate,
                parentSheetDismiss: { isShowingDatePickerSheet = false }
            )
            .presentationDetents([.fraction(0.75)])
            .presentationDragIndicator(.visible)
        }
        .onChange(of: searchText) { _, _ in
            viewModel.applyFilters()
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.05, green: 0.22, blue: 0.38)
            .ignoresSafeArea()
        SearchBarFilterButton(
            viewModel: CashFlowViewModel(),
            searchText: .constant(""),
            selectedPaymentStatus: .constant(nil),
            selectedCategory: .constant(nil),
            startDate: .constant(Date()),
            endDate: .constant(Date()),
            useCustomDateRange: .constant(false),
            minAmountFilter: .constant(""),
            maxAmountFilter: .constant("")
        )
    }
}
