//
//  AddExpenseView.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 26/08/26.
//

import SwiftUI

public struct ExpenseItemInput: Identifiable {
    public let id: UUID
    public var name: String

    public init(id: UUID = UUID(), name: String = "") {
        self.id = id
        self.name = name
    }
}

public struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var transactionDate = Date()
    @State private var dueDate = Date()
    @State private var supplierName = ""
    @State private var supplierPhone = ""
    @State private var items: [IncomeItemInput] = [IncomeItemInput()]
    @State private var paidAmount = ""
    @State private var selectedExpenseCategory: String = ""
    @State private var showErrors = false
    @State private var showCategorySheet = false
    
    
    private var areItemsValid: Bool {
        guard !items.isEmpty else { return false }
        return items.allSatisfy {
            !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    private var isPaidAmountValid: Bool {
        !paidAmount.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                HStack {
                    Text("Tanggal")
                    Spacer()
                    DatePicker("", selection: $transactionDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
                .padding(.leading, 6)
                .padding(10)
                .background(Color.white)
                .cornerRadius(24)
                
                
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("DETAIL BARANG")
                        .font(.caption2.bold())
                        .foregroundStyle(.secondary)
                    
                    ForEach($items) { $item in
                        HStack {
                            VStack(spacing: 10) {
                                HStack {
                                    TextField("cth. Tepung 10 kg", text: $item.name)
                                    Spacer()
                                    
                                    if items.count > 1 {
                                        Button {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                items.removeAll { $0.id == item.id }
                                            }
                                        } label: {
                                            Image(systemName: "trash")
                                                .font(.subheadline)
                                                .foregroundStyle(.red)
                                        }
                                    }
                                }
                                
                                
                                if items.count > 1 {
                                    Divider()
                                }
                            }
                        }
                    }
                    
                    Button {
                        items.append(IncomeItemInput())
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
                
                if showErrors && !areItemsValid {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.circle")
                        Text("Nama barang dan harga wajib diisi")
                        Spacer()
                    }
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.top, -8)
                }
                
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Jumlah yang Dibayar")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 6) {
                        Text("Rp")
                            .foregroundStyle(.secondary)
                        TextField("15.000", text: $paidAmount)
                            .font(.title3.bold())
                            .keyboardType(.numberPad)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(24)
                
                if showErrors && !isPaidAmountValid {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.circle")
                        Text("Jumlah yang dibayar wajib diisi")
                        Spacer()
                    }
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.top, -8)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Kategori")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Button { showCategorySheet = true
                    } label: {
                        HStack {
                            Text(selectedExpenseCategory.isEmpty ? "Pilih kategori" : selectedExpenseCategory)
                                .font(.body)
                                .foregroundStyle(selectedExpenseCategory.isEmpty ? Color(.placeholderText) : Color.primary)
                            
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.footnote.bold())
                                .foregroundStyle(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(24)
                
                
                
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Dibeli dari")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("Toko Pak El", text: $supplierName)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Nomor Telepon / Kontak (opsional)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        TextField("08.....", text: $supplierPhone)
                            .keyboardType(.phonePad)
                            .font(.body)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(24)
                
                
                Button {
                    if  areItemsValid && isPaidAmountValid {
                        dismiss()
                    } else {
                        showErrors = true
                    }
                } label: {
                    Text("Simpan")
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(24)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Tambah Pengluaran")
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
                Text("Tambah Pengeluaran")
                    .font(.headline.bold())
                    .foregroundStyle(.white)
            }
        }
        .sheet(isPresented: $showCategorySheet) {
            ExpenseCategorySheetContent(selectedExpenseCategory: $selectedExpenseCategory)
        }
    }
}

#Preview {
    NavigationStack {
        AddExpenseView()
    }
}
