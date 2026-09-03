import SwiftUI

public struct ExpenseFormView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var categoryStore: CategoryStore
    
    @StateObject public var viewModel: ExpenseFormViewModel
    
    @State private var showCategorySheet = false
    @State private var isShowingDelSheet = false
    @State private var showErrors = false
    
    public init(viewModel: ExpenseFormViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private var selectedCategoryName: String {
        guard let id = viewModel.selectedExpenseCategoryId else { return "" }
        return categoryStore.categories.first(where: { $0.id == id })?.name ?? ""
    }
    
    public var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Memuat data pengeluaran...")
            } else if let errorMessage = viewModel.errorMessage, viewModel.mode != .add {
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
            await viewModel.loadDataIfNeeded(shopId: AppMockData.primaryShop.id)
        }
    }
    
    private var formContent: some View {
        ScrollView {
            VStack(spacing: 12) {
                HStack {
                    Text("Tanggal")
                    Spacer()
                    DatePicker("", selection: $viewModel.transactionDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .foregroundStyle(.blue)
                        .environment(\.locale, Locale(identifier: "id_ID"))
                    Image(systemName: "chevron.right")
                        .font(.footnote.bold())
                        .foregroundStyle(.gray)
                }
                .padding(.leading, 6)
                .padding(10)
                .background(Color.white)
                .cornerRadius(24)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(viewModel.mode == .add ? "DETAIL BARANG" : "APA YANG DIBELI?")
                        .font(.caption2.bold())
                        .foregroundStyle(.gray)
                    
                    ForEach($viewModel.items) { $item in
                        HStack {
                            VStack(spacing: 10) {
                                HStack {
                                    TextField("Nama barang (cth. Tepung 10 kg)", text: $item.name)
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
                                
                                if viewModel.items.count > 1 && item.id != viewModel.items.last?.id {
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
                        Text("Wajib isi minimal satu barang yang dibeli")
                        Spacer()
                    }
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.top, -8)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Jumlah yang Dibayar")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    HStack(spacing: 6) {
                        Text("Rp")
                            .foregroundStyle(.gray)
                        TextField("15.000", text: $viewModel.paidAmountText)
                            .font(.title3.bold())
                            .keyboardType(.numberPad)
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
                        .foregroundStyle(.gray)
                    
                    Button {
                        showCategorySheet = true
                    } label: {
                        HStack {
                            Text(selectedCategoryName.isEmpty ? "Pilih kategori" : selectedCategoryName)
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
                
                if showErrors && viewModel.selectedExpenseCategoryId == nil {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.circle")
                        Text("Kategori pengeluaran wajib dipilih")
                        Spacer()
                    }
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.top, -8)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Dibeli dari")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        TextField("Toko Pak El", text: $viewModel.supplierName)
                            .onChange(of: viewModel.supplierName) { _, newValue in
                                let formatted = newValue.capitalized
                                if formatted != newValue {
                                    viewModel.supplierName = formatted
                                }
                            }
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Nomor Telepon / Kontak (opsional)")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        TextField("08.....", text: $viewModel.supplierPhone)
                            .keyboardType(.phonePad)
                            .font(.body)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(24)
                
                if showErrors && !viewModel.isSupplierNameValid {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.circle")
                        Text("Dibeli dari wajib diisi")
                        Spacer()
                    }
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.top, -8)
                }
                
                if let errorMessage = viewModel.errorMessage, viewModel.mode == .add {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                
                Button {
                    if viewModel.isFormValid {
                        Task {
                            await viewModel.save(
                                shopId: AppMockData.primaryShop.id,
                                userId: AppMockData.currentUser.id
                            )
                        }
                    } else {
                        showErrors = true
                    }
                } label: {
                    Group {
                        if viewModel.isSaving {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text(viewModel.mode == .add ? "Simpan" : "Simpan Perubahan")
                                .font(viewModel.mode == .add ? .body.bold() : .title3.bold())
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(viewModel.mode == .add ? 48 : 24)
                }
                .disabled(viewModel.isSaving)
                .padding(.top, 8)
                
                if case .edit(let expenseId) = viewModel.mode {
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
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(viewModel.mode == .add ? "Tambah Pengeluaran" : "")
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
                Text(viewModel.mode == .add ? "Tambah Pengeluaran" : "Edit Pengeluaran")
                    .font(.headline.bold())
                    .foregroundStyle(.white)
            }
        }
        .sheet(isPresented: $showCategorySheet) {
            ExpenseCategorySheetContent(selectedExpenseCategoryId: $viewModel.selectedExpenseCategoryId)
        }
        .onChange(of: viewModel.isSaved) { _, isSaved in
            if isSaved {
                dismiss()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    NavigationStack {
        ExpenseFormView(viewModel: ExpenseFormViewModel(mode: .add))
            .environmentObject(CategoryStore.shared)
    }
}
