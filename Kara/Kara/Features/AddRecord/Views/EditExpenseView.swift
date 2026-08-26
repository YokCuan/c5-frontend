//
//  EditExpenseView.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 26/08/26.
//

import SwiftUI

public struct EditExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    
    public let expense: Expense
    
    @State private var transactionDate: Date
    @State private var items: [ExpenseItemInput]
    @State private var paidAmount: String
    @State private var selectedExpenseCategory: String
    @State private var supplierName: String
    @State private var supplierPhone: String
    
    @State private var showCategorySheet = false
    @State private var isShowingDelSheet = false
    @State private var showErrors = false
    
    public init(expense: Expense) {
        self.expense = expense
        
        _transactionDate = State(initialValue: expense.purchasedAt)
        
        let mappedItems = expense.items?.map { ExpenseItemInput(name: $0.name ?? "" ) } ?? []
        _items = State(initialValue: mappedItems.isEmpty ? [ExpenseItemInput()] : mappedItems)
        
        _paidAmount = State(initialValue: String(format: "%.0f", expense.paidAmount))
        _selectedExpenseCategory = State(initialValue: expense.category?.name ?? "")
        _supplierName = State(initialValue: expense.supplierName ?? "")
        _supplierPhone = State(initialValue: expense.supplierPhone ?? "")
    }
    
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
            VStack(spacing: 14) {
                HStack {
                    Text("Tanggal")
                        .font(.body)
                    Spacer()
                    DatePicker("", selection: $transactionDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
                .padding(.leading, 6)
                .padding(10)
                .background(Color.white)
                .cornerRadius(24)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("APA YANG DIBELI?")
                        .font(.caption2.bold())
                        .foregroundStyle(.secondary)
                    
                    ForEach($items) { $item in
                        VStack(spacing: 8) {
                            HStack {
                                TextField("cth. Tepung 10 kg", text: $item.name)
                                    .font(.body)
                                
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
                            
                            if items.count > 1 && item.id != items.last?.id {
                                Divider()
                            }
                        }
                    }
                    
                    Divider()
                    
                    Button {
                        items.append(ExpenseItemInput())
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
                        Text("Wajib isi minimal satu barang yang dibeli")
                        Spacer()
                    }
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.top, -6)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Jumlah yang Dibayar")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 6) {
                        Text("Rp")
                            .font(.title3.bold())
                            .foregroundStyle(.secondary)
                        TextField("100.000", text: $paidAmount)
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
                    .padding(.top, -6)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Kategori")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Button {
                        showCategorySheet = true
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
                            .font(.body)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nomor Telepon / Kontak (opsional)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("08.....", text: $supplierPhone)
                            .keyboardType(.phonePad)
                            .font(.body)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(24)
                
                Button {
                    if areItemsValid && isPaidAmountValid {
                        dismiss()
                    } else {
                        showErrors = true
                    }
                } label: {
                    Text("Simpan Perubahan")
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(24)
                }
                .padding(.top, 8)
                
                Button(action: { isShowingDelSheet = true }) {
                    Text("Hapus Pengeluaran")
                        .font(.title3.bold())
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.gray.opacity(0.15))
                        .cornerRadius(24)
                }
                .sheet(isPresented: $isShowingDelSheet) {
                    CashFlowDeleteOutcome()
                        .presentationDetents([.fraction(0.5), .height(.infinity)])
                        .presentationDragIndicator(.visible)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
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
                Text("Edit Pengeluaran")
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
    let dummyCategoryId = UUID()
    let dummyExpense = Expense(
        id: UUID(),
        shopId: UUID(),
        expenseCategoryId: dummyCategoryId,
        supplierName: "Toko Sembako Makmur",
        supplierPhone: "081234567890",
        paidAmount: 350000,
        purchasedAt: Date(),
        createdBy: UUID(),
        updatedBy: UUID(),
        items: [
            ExpenseItem(id: UUID(), expenseId: UUID(), name: "Tepung Terigu Segitiga 25 kg"),
            ExpenseItem(id: UUID(), expenseId: UUID(), name: "Minyak Goreng 5 Liter")
        ],
        category: ExpenseCategory(id: dummyCategoryId, name: "Bahan Baku")
    )
    
    return NavigationStack {
        EditExpenseView(expense: dummyExpense)
    }
}
