//
//  EditExpenseView.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 26/08/26.
//

import SwiftUI

public struct EditExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var categoryStore: CategoryStore
    
    let expenseId: UUID
    
    @State private var expense: Expense? = nil
    @State private var isLoading = true
    @State private var isSaving = false
    @State private var errorMessage: String? = nil
    
    @State private var transactionDate: Date = Date()
    @State private var items: [ExpenseItemInput] = []
    @State private var paidAmount: String = ""
    @State private var selectedExpenseCategory: UUID? = nil
    @State private var supplierName: String = ""
    @State private var supplierPhone: String = ""
    
    @State private var showCategorySheet = false
    @State private var isShowingDelSheet = false
    @State private var showErrors = false
    
    public init(expenseId: UUID) {
        self.expenseId = expenseId
    }
    
    private var selectedCategoryName: String {
        guard let id = selectedExpenseCategory else { return "" }
        return categoryStore.categories.first(where: { $0.id == id })?.name ?? ""
    }
    
    private var areItemsValid: Bool {
        guard !items.isEmpty else { return false }
        return items.allSatisfy {
            !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    private var isPaidAmountValid: Bool {
        let cleaned = paidAmount.replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: ".", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard let amount = Double(cleaned) else { return false }
        return amount > 0
    }
    
    private var parsedPaidAmount: Double {
        let cleaned = paidAmount.replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: ".", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return Double(cleaned) ?? 0.0
    }
    
    public var body: some View {
        Group {
            if isLoading {
                ProgressView("Memuat data pengeluaran...")
            } else if let errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.orange)
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
            } else {
                formContent
            }
        }
        .task {
            await categoryStore.fetchCategoriesIfNeeded()
            await fetchExpenseDetail()
        }
    }
    
    private var formContent: some View {
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
                        .foregroundStyle(.gray)
                    
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
                        .foregroundStyle(.gray)
                    
                    HStack(spacing: 6) {
                        Text("Rp")
                            .font(.title3.bold())
                            .foregroundStyle(.gray)
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
                        .foregroundStyle(.gray)
                    
                    Button {
                        showCategorySheet = true
                    } label: {
                        HStack {
                            Text(
                                selectedCategoryName.isEmpty ? "Pilih kategori" : selectedCategoryName
                            )
                            .font(.body)
                            .foregroundStyle(selectedCategoryName.isEmpty ? Color(.placeholderText) : Color.black)
                            
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
                            .foregroundStyle(.gray)
                        TextField("Toko Pak El", text: $supplierName)
                            .font(.body)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nomor Telepon / Kontak (opsional)")
                            .font(.caption)
                            .foregroundStyle(.gray)
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
                        Task {
                            await updateExpense()
                        }
                    } else {
                        showErrors = true
                    }
                } label: {
                    Group {
                        if isSaving {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Simpan Perubahan")
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(24)
                }
                .disabled(isSaving)
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
                    CashFlowDeleteOutcome(
                        expenseId: expenseId,
                        shopId: AppMockData.primaryShop.id
                    ) {
                        dismiss()
                    }
                    .presentationDetents([.fraction(0.45)])
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
            ExpenseCategorySheetContent(selectedExpenseCategoryId: $selectedExpenseCategory)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    private func setupForm(with expense: Expense) {
        transactionDate = expense.purchasedAt
        let mappedItems = expense.items?.map { ExpenseItemInput(name: $0.name ?? "") } ?? []
        items = mappedItems.isEmpty ? [ExpenseItemInput()] : mappedItems
        paidAmount = String(format: "%.0f", expense.paidAmount)
        selectedExpenseCategory = expense.expenseCategoryId
        supplierName = expense.supplierName ?? ""
        supplierPhone = expense.supplierPhone ?? ""
    }
    
    @MainActor
    private func fetchExpenseDetail() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedExpense = try await APIService.shared.fetchExpenseDetail(
                id: expenseId,
                shopId: AppMockData.primaryShop.id
            )
            self.expense = fetchedExpense
            setupForm(with: fetchedExpense)
            self.isLoading = false
        } catch {
            self.errorMessage = "Gagal memuat detail pengeluaran: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
    
    @MainActor
    private func updateExpense() async {
        guard let categoryId = selectedExpenseCategory else {
            errorMessage = "Kategori wajib dipilih."
            return
        }
        
        isSaving = true
        errorMessage = nil
        
        let itemsArray: [[String: String]] = items.compactMap { item in
            let trimmed = item.name.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? nil : ["name": trimmed]
        }
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let formattedDate = formatter.string(from: transactionDate)
        
        let rawBody: [String: Any] = [
            "expenseCategoryId": categoryId.uuidString,
            "supplierName": supplierName.trimmingCharacters(in: .whitespacesAndNewlines),
            "supplierPhone": supplierPhone.trimmingCharacters(in: .whitespacesAndNewlines),
            "paidAmount": parsedPaidAmount,
            "purchasedAt": formattedDate,
            "createdBy": AppMockData.currentUser.id.uuidString,
            "updatedBy": AppMockData.currentUser.id.uuidString,
            "items": itemsArray
        ]
        
        do {
            try await APIService.shared.patchExpense(
                id: expenseId,
                shopId: AppMockData.primaryShop.id,
                body: rawBody
            )
            isSaving = false
            dismiss()
        } catch {
            isSaving = false
            self.errorMessage = "Gagal menyimpan perubahan: \(error.localizedDescription)"
        }
    }
}

#Preview {
    NavigationStack {
        EditExpenseView(expenseId: UUID())
            .environmentObject(CategoryStore.shared)
    }
}
