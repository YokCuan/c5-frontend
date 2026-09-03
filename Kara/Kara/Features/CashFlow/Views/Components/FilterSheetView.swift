//
//  FilterSheetView.swift
//  Kara
//
//  Created by Samuel Bonardo on 23/08/26.
//

import SwiftUI

struct FilterSheetView: View {
    
    @Binding var selectedPaymentStatus: PaymentStatus?
    @Binding var selectedCategory: CategoryFilterOption?
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var useCustomDateRange: Bool
    @Binding var minAmountFilter: String
    @Binding var maxAmountFilter: String
    
    @ObservedObject var viewModel: CashFlowViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDateRange: DateRange? = nil
    @State private var isShowingCategorySheet: Bool = false
    @State private var isShowingDatePickerSheet = false
    
    @State private var amount: Int = 0
    
    enum DateRange: String, CaseIterable {
        case last7Days = "7 hari terakhir"
        case thisMonth = "Bulan Ini"
        case custom = "Atur rentang tanggal"
    }
    
    private var isAmountRangeInvalid: Bool {
        guard let min = Int(minAmountFilter), let max = Int(maxAmountFilter),
              !minAmountFilter.isEmpty, !maxAmountFilter.isEmpty else {
            return false
        }
        return min > max
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            HStack {
                Text("Filter Transaksi")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                
                Spacer()
                
                // MARK: - Custom Header (Bukan Toolbar)
                Button {
                    resetFilter()
                } label: {
                    Text("Pulihkan")
                        .font(.headline)
                        .fontWeight(.bold)
                        .underline()
                        .foregroundStyle(.gray)
                }
                .buttonStyle(.plain)
            }
            
            activeFilterChips
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("Rentang waktu")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(DateRange.allCases, id: \.self) { range in
                            dateRangeRow(range)
                        }
                    }
                    
                    Divider()
                    
                    Text("Besar transaksi")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                    
                    HStack(spacing: 16) {
                        amountField(label: "Dari", value: $minAmountFilter, isInvalid: isAmountRangeInvalid)
                        amountField(label: "Sampai", value: $maxAmountFilter, isInvalid: isAmountRangeInvalid)                    }
                    .font(.subheadline)
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity, alignment:.center)
                    
                    if isAmountRangeInvalid {
                        Text("Besar akhir harus lebih tinggi dari besar awal")
                            .font(.caption)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Divider()
                    
                    Text("Kategori")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                    Button {
                            isShowingCategorySheet = true
                        } label: {
                            HStack {
                                Text(selectedCategory?.title ?? "Pilih kategori")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.black)
                                 
                                Spacer()
                                 
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color.black)
                            }
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                }
            }
            
            // MARK: - Bottom Action Button
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
                    .clipShape(RoundedRectangle(cornerRadius: 48))
            }
            .disabled(isAmountRangeInvalid)
            .padding(.vertical)
        }
        .padding(.horizontal)
        .padding(.top, 32)
        .presentationDragIndicator(.visible)
        .sheet(isPresented: $isShowingCategorySheet) {
            SheetFilterCategory(
                selectedCategory: $selectedCategory,
                parentSheetDismiss: { dismiss() }
            )
            .presentationDetents([.fraction(0.75)])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isShowingDatePickerSheet) {
            SheetDatePicker(
                startDate: $startDate,
                endDate: $endDate,
                parentSheetDismiss: { dismiss() }
            )
            .presentationDetents([.fraction(0.75)])
            .presentationDragIndicator(.visible)
        }
        .onAppear {
            syncSelectedDateRange()
        }
        .onChange(of: startDate) { _, _ in
            syncSelectedDateRange()
        }
        .onChange(of: endDate) { _, _ in
            syncSelectedDateRange()
        }
        .onChange(of: useCustomDateRange) { _, _ in
            syncSelectedDateRange()
        }
    }
    
    @ViewBuilder
    private func dateRangeRow(_ range: DateRange) -> some View {
        Button {
            selectRange(range)
        } label: {
            HStack {
                Text(range.rawValue)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                
                Spacer()
                
                Image(systemName: selectedDateRange == range ? "largecircle.fill.circle" : "circle")
                    .font(.subheadline)
                    .foregroundStyle(selectedDateRange == range ? .blue : .gray)
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
        private func amountField(label: String, value: Binding<String>, isInvalid: Bool) -> some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)
                 
                HStack (spacing: 0){
                    Text("Rp ")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                    
                    TextField("0", text: value)
                        .keyboardType(.numberPad)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                        .onChange(of: value.wrappedValue) { _, newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            let formatted = filtered.formattedWithSeparator
                            if formatted != newValue {
                                value.wrappedValue = formatted
                            }
                        }
                    if !value.wrappedValue.isEmpty{
                        Button(action: {
                            value.wrappedValue = ""
                        }) {
                            Image(systemName: "xmark.circle")
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isInvalid ? Color.red : Color.clear, lineWidth: 2)
            )
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    
    private func selectRange(_ range: DateRange) {
        selectedDateRange = range
        
        let calendar = Calendar.current
        let today = Date()
        
        switch range {
        case .last7Days:
            startDate = calendar.date(byAdding: .day, value: -6, to: today) ?? today
            endDate = today
            useCustomDateRange = true
            
        case .thisMonth:
            let monthStart = monthStartDate(for: viewModel.selectedDate)
            let monthEnd = monthEndDate(for: viewModel.selectedDate)
            startDate = monthStart
            endDate = monthEnd
            useCustomDateRange = false
            
        case .custom:
            useCustomDateRange = true
            isShowingDatePickerSheet = true
        }
    }
    
    private func resetFilter() {
        minAmountFilter = ""
        maxAmountFilter = ""
        selectedCategory = nil
        selectedPaymentStatus = nil
        useCustomDateRange = false
        let monthStart = monthStartDate(for: viewModel.selectedDate)
        let monthEnd = monthEndDate(for: viewModel.selectedDate)
        startDate = monthStart
        endDate = monthEnd
        viewModel.applyFilters()
        dismiss()
    }
    
    private func applyFilter() {
        viewModel.applyFilters()
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
    
    private func syncSelectedDateRange() {
        let calendar = Calendar.current
        let monthStart = monthStartDate(for: viewModel.selectedDate)
        let monthEnd = monthEndDate(for: viewModel.selectedDate)
        
        if startDate == monthStart && endDate == monthEnd && !useCustomDateRange {
            selectedDateRange = .thisMonth
            return
        }
        
        if calendar.isDate(startDate, inSameDayAs: calendar.date(byAdding: .day, value: -6, to: Date()) ?? Date())
            && calendar.isDate(endDate, inSameDayAs: Date())
            && useCustomDateRange {
            selectedDateRange = .last7Days
            return
        }
        
        if useCustomDateRange {
            selectedDateRange = .custom
        } else {
            selectedDateRange = nil
        }
    }
    
    @ViewBuilder
    private var activeFilterChips: some View {
        let chips = [
            selectedPaymentStatus?.title,
            selectedCategory?.title,
            selectedDateRange?.rawValue
        ].compactMap { $0 }
        
        if chips.isEmpty {
            EmptyView()
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(chips, id: \.self) { chip in
                        Text(chip)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(Capsule())
                    }
                }
                .frame(alignment: .leading)
            }
        }
    }
}


#Preview {
    FilterSheetView(
        selectedPaymentStatus: .constant(nil),
        selectedCategory: .constant(nil),
        startDate: .constant(Date()),
        endDate: .constant(Date()),
        useCustomDateRange: .constant(false),
        minAmountFilter: .constant(""),
        maxAmountFilter: .constant(""),
        viewModel: CashFlowViewModel()
    )
}
