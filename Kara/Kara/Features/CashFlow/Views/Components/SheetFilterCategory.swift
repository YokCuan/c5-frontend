//
//  SheetFilterCategory.swift
//  Kara
//
//  Created by Samuel Bonardo on 24/08/26.
//

import SwiftUI

enum CategoryFilterOption: Equatable, Hashable {
    case all
    case incomeStatus(PaymentStatus)
    case expenseItem(ExpenseCategory)
    
    var title: String {
        switch self {
        case .all:
            return "Semua"
        case .incomeStatus(let status):
            return status.title
        case .expenseItem(let category):
            return category.name
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
                Color.clear
                    .frame(width: 32, height: 32)
                
                Spacer()
                
                Text("Pilih kategori")
                    .font(.headline.bold())
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Button {
                    dismiss()
                    parentSheetDismiss?()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color.secondary.opacity(0.8))
                }
                .frame(width: 32, height: 32)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            // MARK: - List Pilihan Kategori
            List {
                // Section Semua
                Section {
                    categoryRow(option: .all)
                } header: {
                    Text("SEMUA KATEGORI")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                // Section Pemasukan (Header teks di luar selectable)
                Section {
                    categoryRow(option: .incomeStatus(.paid))
                    categoryRow(option: .incomeStatus(.dp))
                    categoryRow(option: .incomeStatus(.notPaid))
                } header: {
                    Text("PEMASUKAN")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                // Section Pengeluaran (Header teks di luar selectable)
                Section {
                    ForEach(expenseCategories) { expenseCategory in
                        categoryRow(option: .expenseItem(expenseCategory))
                    }
                } header: {
                    Text("PENGELUARAN")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .listStyle(.insetGrouped)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Helper Row Component
    @ViewBuilder
    private func categoryRow(option: CategoryFilterOption) -> some View {
        Button {
            selectedCategory = option
            dismiss()
        } label: {
            HStack {
                Text(option.title)
                    .font(.body)
                    .foregroundStyle(.primary)
                
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
            Text("Test Page")
                .sheet(isPresented: .constant(true)) {
                    SheetFilterCategory(selectedCategory: $selected)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
        }
    }
    
    return PreviewContainer()
}
