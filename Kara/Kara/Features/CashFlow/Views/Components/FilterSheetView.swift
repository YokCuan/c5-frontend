//
//  FilterSheetView.swift
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
    @State private var selectedCategory: String? = nil
    
    enum DateRange: String, CaseIterable {
        case last7Days = "7 hari terakhir"
        case thisMonth = "Bulan Ini"
        case custom = "Atur rentang tanggal"
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Filter Kas")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("Pulihkan") {
                    resetFilter()
                }
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .underline()
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 20)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Rentang waktu
                    Text("Rentang waktu")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(DateRange.allCases, id: \.self) { range in
                            dateRangeRow(range)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Divider()
                    
                    // Besar transaksi
                    Text("Besar transaksi")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    
                    HStack {
                        amountField(label: "Dari", value: $minAmount)
                        amountField(label: "Ke", value: $maxAmount)
                    }
                    .padding(.horizontal, 24)
                    
                    Divider()
                    
                    // Kategori
                    Text("Kategori")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    
                    Button {
                        // Nanti navigasi ke halaman pilih kategori
                    } label: {
                        HStack {
                            Text(selectedCategory ?? "Pilih kategori")
                                .font(.headline)
                                .foregroundStyle(Color.primary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.primary)
                        }
                        .padding(.horizontal, 24)
                    }
                }
            }
            
            // Terapkan filter
            Button {
                applyFilter()
                dismiss()
            } label: {
                Text("Terapkan Filter")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
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
        .clipShape(RoundedRectangle(cornerRadius: 12))
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

// MARK: - Working Preview Setup
#Preview {
    struct PreviewContainer: View {
        @State private var status: PaymentStatus? = nil
        @State private var start = Date()
        @State private var end = Date()
        
        var body: some View {
            FilterSheetView(
                selectedPaymentStatus: $status,
                startDate: $start,
                endDate: $end,
                viewModel: CashFlowViewModel()
            )
        }
    }
    
    return PreviewContainer()
}
