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
    @EnvironmentObject var categoryStore: CategoryStore
    
    @StateObject private var viewModel = AddExpenseViewModel()
    
    @State private var showErrors = false
    @State private var showCategorySheet = false
    
    private var selectedCategoryName: String {
        guard let id = viewModel.selectedExpenseCategoryId else { return "" }
        return categoryStore.categories.first(where: { $0.id == id })?.name ?? ""
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                if let apiError = viewModel.errorMessage {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text(apiError)
                        Spacer()
                    }
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                }
                
                HStack {
                    Text("Tanggal")
                    Spacer()
                    DatePicker("", selection: $viewModel.transactionDate, displayedComponents: .date)
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
                    
                    ForEach($viewModel.items) { $item in
                        HStack {
                            VStack(spacing: 10) {
                                HStack {
                                    TextField("cth. Tepung 10 kg", text: $item.name)
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
                        Text("Nama barang wajib diisi")
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
                        TextField("15.000", text: $viewModel.paidAmountText)
                            .font(.title3.bold())
                            .keyboardType(.numberPad)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(24)
                
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
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Kategori")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Button {
                        showCategorySheet = true
                    } label: {
                        HStack {
                            Text(selectedCategoryName.isEmpty ? "Pilih kategori" : selectedCategoryName)
                                .font(.body)
                                .foregroundStyle(selectedCategoryName.isEmpty ? Color(.placeholderText) : Color.primary)
                            
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
                        TextField("Toko Pak El", text: $viewModel.supplierName)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Nomor Telepon / Kontak (opsional)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        TextField("08.....", text: $viewModel.supplierPhone)
                            .keyboardType(.phonePad)
                            .font(.body)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(24)
                
                Button {
                    if viewModel.areItemsValid && viewModel.isPaidAmountValid {
                        Task {
                            await viewModel.createExpense(
                                shopId: AppMockData.primaryShop.id,
                                userId: AppMockData.currentUser.id
                            )
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
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(24)
                }
                .disabled(viewModel.isLoading)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Tambah Pengeluaran")
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
            ExpenseCategorySheetContent(selectedExpenseCategoryId: $viewModel.selectedExpenseCategoryId)
        }
        .onChange(of: viewModel.isSaved) { oldValue, newValue in
            if newValue {
                dismiss()
            }
        }
        .task {
            await categoryStore.fetchCategoriesIfNeeded()
        }
    }
}

#Preview {
    NavigationStack {
        AddExpenseView()
            .environmentObject(CategoryStore.shared)
    }
}
