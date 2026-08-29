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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                // MARK: - Custom Header (Bukan Toolbar)
                HStack {
                    Text("Filter Transaksi")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
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
                .padding(.top, 16)
                
                activeFilterChips
                
                // MARK: - Body Content
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Rentang waktu
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
                    
                    // Besar transaksi
                    Text("Besar transaksi")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                    
                    
                    HStack (spacing: 16) {
                        amountField(label: "Dari", value: $minAmountFilter)
                        amountField(label: "Ke", value: $maxAmountFilter)
                    }
                    .font(.subheadline)
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity, alignment:.center)
                    
                    
                    Divider()
                    
                    // Kategori
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
                    }
                    .buttonStyle(.plain)
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
            }
            .padding(.top, 8)
            .padding()
        }
        .background(Color(.systemBackground))
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
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
    private func amountField(label: String, value: Binding<String>) -> some View {
        let intBinding = Binding<Int>(
            get: { Int(value.wrappedValue) ?? 0 },
            set: { value.wrappedValue = $0 == 0 ? "" : String($0) }
        )
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
                
                TextField("0", value: intBinding, format: .number.locale(Locale(identifier: "id_ID")))
                    .keyboardType(.numberPad)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Functions
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

// MARK: - Preview
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
