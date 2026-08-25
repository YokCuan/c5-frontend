//
//  FilterSheetView.swift
//  Kara
//
//  Created by Samuel Bonardo on 23/08/26.
//

import SwiftUI

struct FilterSheetView: View {
    
    @Binding var selectedPaymentStatus: PaymentStatus?
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    @ObservedObject var viewModel: CashFlowViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDateRange: DateRange? = nil
    @State private var minAmount: String = ""
    @State private var maxAmount: String = ""
    
    @State private var selectedCategory: CategoryFilterOption? = nil
    @State private var isShowingCategorySheet: Bool = false
    
    enum DateRange: String, CaseIterable {
        case last7Days = "7 hari terakhir"
        case thisMonth = "Bulan Ini"
        case custom = "Atur rentang tanggal"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Custom Header (Bukan Toolbar)
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
            .padding(.horizontal)
            .padding(.top)
            .padding(.bottom)
            
            // MARK: - Body Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Rentang waktu
                    Text("Rentang waktu")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(DateRange.allCases, id: \.self) { range in
                            dateRangeRow(range)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // Besar transaksi
                    Text("Besar transaksi")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    HStack {
                        amountField(label: "Dari", value: $minAmount)
                        amountField(label: "Ke", value: $maxAmount)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // Kategori
                    Button {
                        isShowingCategorySheet = true
                    } label: {
                        HStack {
                            Text(selectedCategory?.title ?? "Pilih kategori")
                                .font(.headline)
                                .foregroundStyle(selectedCategory == nil ? .secondary : Color.primary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.primary)
                        }
                        .padding(.horizontal)
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
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
        .presentationDragIndicator(.visible)
        .sheet(isPresented: $isShowingCategorySheet) {
            SheetFilterCategory(
                selectedCategory: $selectedCategory,
                parentSheetDismiss: { dismiss() }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
    
    @ViewBuilder
    private func dateRangeRow(_ range: DateRange) -> some View {
        Button {
            selectedDateRange = range
        } label: {
            HStack {
                Text(range.rawValue)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Image(systemName: selectedDateRange == range ? "largecircle.fill.circle" : "circle")
                    .font(.title2)
                    .foregroundStyle(selectedDateRange == range ? .blue : .secondary)
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func amountField(label: String, value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            TextField("Rp0", text: value)
                .keyboardType(.numberPad)
                .font(.headline)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Functions
    private func resetFilter() {
        selectedDateRange = nil
        minAmount = ""
        maxAmount = ""
        selectedCategory = nil
        selectedPaymentStatus = nil
    }
    
    private func applyFilter() {
        Task {
            await viewModel.loadTransactions()
        }
    }
}

// MARK: - SwiftUI Canvas Preview
#Preview {
    FilterSheetView(
        selectedPaymentStatus: .constant(nil),
        startDate: .constant(Date()),
        endDate: .constant(Date()),
        viewModel: CashFlowViewModel()
    )
}
