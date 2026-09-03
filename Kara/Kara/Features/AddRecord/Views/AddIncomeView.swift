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
    @FocusState private var isPaidAmountFocused: Bool
    
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
                                .foregroundStyle(.gray)
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
                                    .foregroundStyle(.gray)
                            }
                            TextField("08.....", text: $viewModel.customerPhone)
                                .keyboardType(.phonePad)
                                .font(.body)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(24)
                    
                    if showErrors && !viewModel.isCustomerNameValid {
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
                            .foregroundStyle(.gray)
                        
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
                                                .foregroundStyle(.gray)
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 10)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                        
                                        Text("x")
                                            .font(.body.bold())
                                            .foregroundStyle(.gray)
                                        
                                        HStack(spacing: 4) {
                                            Text("Rp")
                                                .font(.subheadline)
                                                .foregroundStyle(.gray)
                                            TextField("Harga satuan", text: $item.unitPriceText)
                                                .keyboardType(.numberPad)
                                                .onChange(
                                                    of: item.unitPriceText
                                                ) { _, newValue in
                                                    let formatted = newValue.formattedWithSeparator
                                                    if formatted != newValue {
                                                        item.unitPriceText = formatted
                                                    }
                                                }
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
                    
                    VStack(spacing: 12) {
                        HStack {
                            Text("Total")
                                .font(.body)
                                .foregroundStyle(.gray)
                            Spacer()
                            Text(viewModel.calculatedTotal.toIDR)
                                .font(.headline.bold())
                        }
                        
                        Divider()
                        
                        Toggle("Belum lunas?", isOn: $viewModel.isBelumLunas)
                            .font(.body)
                            .tint(.blue)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(24)
                    
                    if viewModel.isBelumLunas {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Sudah Dibayar")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            HStack(spacing: 6) {
                                Text("Rp")
                                    .foregroundStyle(.gray)
                                TextField("0", text: $viewModel.paidAmountText)
                                    .font(.title3.bold())
                                    .keyboardType(.numberPad)
                                    .focused($isPaidAmountFocused)
                                    .onChange(of: isPaidAmountFocused) { _, isFocused in
                                        if isFocused && viewModel.paidAmountText == "0" {
                                            viewModel.paidAmountText = ""
                                        }
                                        if !isFocused && viewModel.paidAmountText.isEmpty {
                                            viewModel.paidAmountText = "0"
                                        }
                                    }
                                    .onChange(of: viewModel.paidAmountText) { _, newValue in
                                        let formatted = newValue.formattedWithSeparator
                                        if formatted != newValue {
                                            viewModel.paidAmountText = formatted
                                        }
                                    }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(viewModel.isPaidAmountExceedingTotal ? Color.red : Color.clear, lineWidth: 2)
                        )
                    }
                    
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
                    
                    if viewModel.isPaidAmountExceedingTotal {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.circle")
                            Text("Nominal melebihi total harga barang")
                            Spacer()
                        }
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.top, -8)
                    }
                    
                    if viewModel.isBelumLunas {
                        VStack {
                            HStack {
                                Text("Sisa Pembayaran")
                                    .font(.body)
                                    .foregroundStyle(.gray)
                                Spacer()
                                Text(viewModel.remainingAmount.toIDR)
                                    .bold()
                                    .foregroundStyle(.red)
                            }
                            
                            Divider()
                            
                            HStack(alignment: .center) {
                                Text("Status")
                                    .font(.body)
                                    .foregroundStyle(.gray)
                                Spacer()
                                
                                if viewModel.remainingAmount == viewModel.calculatedTotal {
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
                                    .foregroundStyle(.gray)
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
                        if viewModel.isFormValid {
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
