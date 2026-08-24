//
//  SheetFilterCategory.swift
//  Kara
//
//  Created by Samuel Bonardo on 24/08/26.
//

import SwiftUI

// 1. Enum untuk mengakomodasi pilihan utama maupun sub-pilihan
enum CategoryFilterOption: Equatable, Hashable {
    case all                         // Semua
    case income                      // Pemasukan (Utama)
    case incomeStatus(PaymentStatus) // Sub: Lunas, DP, Belum bayar
    case expense                     // Pengeluaran (Utama)
    case expenseItem(ExpenseCategory)// Sub: Pengeluaran dari struct ExpenseCategory temanmu
    
    var title: String {
        switch self {
        case .all:
            return "Semua"
        case .income:
            return "Pemasukan"
        case .incomeStatus(let status):
            return status.title
        case .expense:
            return "Pengeluaran"
        case .expenseItem(let category):
            return category.name // Mengambil properti .name dari struct ExpenseCategory
        }
    }
}

struct SheetFilterCategory: View {
    @Binding var selectedCategory: CategoryFilterOption?
    
    var expenseCategories: [ExpenseCategory] = ExpenseCategory.defaults
    var parentSheetDismiss: (() -> Void)? = nil
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Custom Header Bar
            HStack {
                // Tombol Panah Kiri (Back)
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                }
                
                Spacer()
                
                // Subjudul (Tengah)
                Text("Pilih kategori")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                // Tombol Silang X (Kanan)
                Button {
                    dismiss()
                    parentSheetDismiss?()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            .padding(.bottom)
            
            // MARK: - List Pilihan Kategori
            List {
                // MARK: - Section Semua
                Section {
                    categoryRow(option: .all, isHeaderOption: true)
                } header: {
                    Text("SEMUA KATEGORI")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                // MARK: - Section Pemasukan
                Section {
                    categoryRow(option: .income, isHeaderOption: true)
                    categoryRow(option: .incomeStatus(.paid), isSubOption: true)
                    categoryRow(option: .incomeStatus(.dp), isSubOption: true)
                    categoryRow(option: .incomeStatus(.notPaid), isSubOption: true)
                }
                
                // MARK: - Section Pengeluaran
                Section {
                    categoryRow(option: .expense, isHeaderOption: true)
                    ForEach(expenseCategories) { expenseName in
                        categoryRow(option: .expenseItem(expenseName), isSubOption: true)
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
    }
    
    // MARK: - Helper Row Component
    @ViewBuilder
    private func categoryRow(option: CategoryFilterOption, isHeaderOption: Bool = false, isSubOption: Bool = false) -> some View {
        Button {
            selectedCategory = option
            dismiss()
        } label: {
            HStack {
                Text(option.title)
                    .font(isHeaderOption ? .headline : (isSubOption ? .subheadline : .body))
                    .fontWeight(isHeaderOption ? .bold : .regular)
                    .foregroundStyle(.primary)
                    .padding(.leading, isSubOption ? 16 : 0)
                
                Spacer()
                
                if selectedCategory == option {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.blue)
                        .fontWeight(.semibold)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview Setup
#Preview {
    struct PreviewContainer: View {
        @State private var selected: CategoryFilterOption? = .incomeStatus(.paid)
        
        var body: some View {
            Text("tes page")
                .sheet(isPresented: .constant(true)) {
                    SheetFilterCategory(selectedCategory: $selected)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
        }
    }
    
    return PreviewContainer()
}
