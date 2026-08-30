//
//  AddIncomeView.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 25/08/26.
//

import SwiftUI

public struct AddIncomeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddSalesNoteViewModel()
    
    @State private var showErrors = false
    
    private var calculatedTotal: Double {
        viewModel.items.reduce(0) { total, item in
            let qty = Double(item.quantityText) ?? 0
            let unitPrice = Double(item.unitPriceText.replacingOccurrences(of: ".", with: "")) ?? 0
            return total + (qty * unitPrice)
        }
    }
    
    private var remainingAmount: Double {
        let cleanPaid = viewModel.parsedPaidAmount ?? 0
        return max(0, calculatedTotal - cleanPaid)
    }
    
    private var isCustomerNameValid: Bool {
        !viewModel.customerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var isPaidAmountExceedingTotal: Bool {
        let paid = viewModel.parsedPaidAmount ?? 0
        return calculatedTotal > 0 && paid > calculatedTotal
    }

    private var isFormValid: Bool {
        isCustomerNameValid
        && viewModel.areItemsValid
        && viewModel.isPaidAmountValid
        && !isPaidAmountExceedingTotal
    }
    
    public var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 12) {
                    HStack {
                        Text("Tanggal")
                        Spacer()
                        DatePicker("", selection: $viewModel.soldAt, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .foregroundStyle(.blue)
                            .environment(\.locale, Locale (identifier: "id_ID"))
                        Image(systemName: "chevron.right")
                            .font(.footnote.bold())
                            .foregroundStyle(.gray)
                    }
                    .padding(.leading, 6)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(24)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Nama Pembeli")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField("Bu Ria", text: $viewModel.customerName)
                                .onChange(of: viewModel.customerName) { _, newValue in
                                            let formatted = newValue.capitalized
                                            if formatted != newValue {
                                                viewModel.customerName = formatted
                                            }
                                        }
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Nomor Telepon (opsional)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            TextField("08.....", text: $viewModel.customerPhone)
                                .keyboardType(.phonePad)
                                .font(.body)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(24)
                    
                    if showErrors && !isCustomerNameValid {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.circle")
                            Text("Nama pembeli wajib diisi")
                            Spacer()
                        }
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.top, -8)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("DETAIL BARANG")
                            .font(.caption2.bold())
                            .foregroundStyle(.secondary)
                        
                        ForEach($viewModel.items) { $item in
                            HStack {
                                VStack(spacing: 10) {
                                    HStack {
                                        TextField("Nama barang (cth. Keripik Tempe 250 g)", text: $item.name)
                                        Spacer()
                                        
                                        if viewModel.items.count > 1 {
                                            Button {
                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                    viewModel.removeItem(id: item.id)
                                                }
                                            } label: {
                                                Image(systemName: "trash")
                                                    .font(.subheadline)
                                                    .foregroundStyle(.red)
                                            }
                                        }
                                    }
                                    
                                    Divider()
                                    
                                    HStack(spacing: 12) {
                                        HStack(spacing: 4) {
                                            TextField("1", text: $item.quantityText)
                                                .keyboardType(.numberPad)
                                                .multilineTextAlignment(.center)
                                                .frame(width: 40)
                                            Text("pcs")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 10)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                        
                                        HStack(spacing: 4) {
                                            Text("Rp")
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                            TextField("15.000", text: $item.unitPriceText)
                                                .keyboardType(.numberPad)
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                    }
                                    
                                    if viewModel.items.count > 1 {
                                        Divider()
                                    }
                                }
                            }
                        }
                        
                        Button {
                            viewModel.addItem()
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "plus.circle")
                                Text("Tambah Barang")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(24)
                    
                    if showErrors && !viewModel.areItemsValid {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.circle")
                            Text("Nama barang, jumlah, dan harga wajib diisi valid")
                            Spacer()
                        }
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.top, -8)
                    }
                    
                    if calculatedTotal > 0 {
                        HStack {
                            Text("Total")
                                .font(.body)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(calculatedTotal.toIDR)
                                .font(.headline.bold())
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(24)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Sudah Dibayar")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        HStack(spacing: 6) {
                            Text("Rp")
                                .foregroundStyle(.secondary)
                            TextField("15.000", text: $viewModel.paidAmountText)
                                .font(.title3.bold())
                                .keyboardType(.numberPad)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(isPaidAmountExceedingTotal ? Color.red : Color.clear, lineWidth: 2)
                    )
                    
                    if showErrors && !viewModel.isPaidAmountValid {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.circle")
                            Text("Jumlah yang dibayar wajib diisi")
                            Spacer()
                        }
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.top, -8)
                    }
                    
                    if isPaidAmountExceedingTotal {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.circle")
                            Text("Nominal melebihi total harga barang")
                            Spacer()
                        }
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.top, -8)
                    }
                    
                    if remainingAmount > 0 && !viewModel.paidAmountText.isEmpty {
                        VStack {
                            HStack {
                                Text("Sisa Pembayaran")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(remainingAmount.toIDR)
                                    .bold()
                                    .foregroundStyle(.red)
                            }
                            
                            Divider()
                            
                            HStack(alignment: .center) {
                                Text("Status")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                
                                if remainingAmount == calculatedTotal {
                                    Text("Belum Bayar")
                                        .foregroundStyle(.white)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 10)
                                        .background(Color.red)
                                        .cornerRadius(30)
                                } else {
                                    Text("DP")
                                        .foregroundStyle(.white)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 10)
                                        .background(Color.orange)
                                        .cornerRadius(30)
                                }
                            }
                            
                            Divider()
                            
                            HStack(alignment: .center) {
                                Text("Jatuh Tempo")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                DatePicker(
                                    "",
                                    selection: $viewModel.dueAt,
                                    displayedComponents: .date
                                )
                                .datePickerStyle(.compact)
                                .onAppear {
                                    viewModel.hasDueDate = true
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(24)
                    } else {
                        Color.clear
                            .frame(height: 0)
                            .onAppear {
                                viewModel.hasDueDate = false
                            }
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    
                    Button {
                        if isCustomerNameValid && viewModel.areItemsValid && viewModel.isPaidAmountValid {
                            Task {
                                await viewModel.createSalesNote(
                                    shopId: AppMockData.primaryShop.id,
                                    userId: AppMockData.currentUser.id
                                )
                                if viewModel.isSaved {
                                    dismiss()
                                }
                            }
                        } else {
                            showErrors = true
                        }
                    } label: {
                        Group {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Simpan")
                                    .font(.body.bold())
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(48)
                    }
                    .disabled(viewModel.isLoading)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Tambah Pemasukan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(
                LinearGradient(
                    colors: [Color.karaBlueDark, Color.karaBlue],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Tambah Pemasukan")
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddIncomeView()
    }
}
