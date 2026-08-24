//
//  FilterSheetView.swift
//
//
//  Created by Samuel Bonardo on 23/08/26.
//

import SwiftUI

struct FilterSheetView: View {
    
    @Binding var selectedPaymentStatus: PaymentStatus?
    @Binding var startDate: Date
    @Binding var endDate: Date
    
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
        VStack(spacing: 24) {
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
                .foregroundStyle(.gray)
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
                        .foregroundStyle(.gray)
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
                        .foregroundStyle(.gray)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    
                    HStack {
                        amountField(label: "Dari", value: $minAmount)
                        
                        amountField(label: "Ke", value: $maxAmount)
                    }
                    .padding(.horizontal, 24)
                    
                    Divider()
                    
                    // Besar transaksi
                    Text("Kategori")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    
                    Button {
                        // nanti navigasi ke halaman pilih kategori
                    } label: {
                        HStack {
                            Text(selectedCategory ?? "Pilih kategori")
                                .font(.headline)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.black)
                        }
                        .padding(.horizontal, 24)
                        
                    }
                }
            }
            //Terapkan filter
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
                    .foregroundStyle(.black)
                
                Spacer()
                
                Image(systemName: selectedDateRange == range ? "largecircle.fill.circle" : "circle")
                    .font(.title2)
                    .foregroundStyle(selectedDateRange == range ? .blue : .gray)
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func amountField(label: String, value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.gray)
            
            TextField("Rp0", text: value)
                .keyboardType(.numberPad)
                .font(.headline)
        }
        .padding()
        .background(Color(.systemGray6))
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
        // logika buat nerapin filter, misal nge-set startDate/endDate
        // berdasarkan selectedDateRange yang dipilih user
    }
}

#Preview {
    @Previewable @State var selectedPaymentStatus: PaymentStatus? = nil
    @Previewable @State var startDate = Date()
    @Previewable @State var endDate = Date()
    
    FilterSheetView(
        selectedPaymentStatus: $selectedPaymentStatus,
        startDate: $startDate,
        endDate: $endDate
    )
}
