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
    @EnvironmentObject var categoryStore: CategoryStore
    
    var parentSheetDismiss: (() -> Void)? = nil
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Color.clear
                    .frame(width: 32, height: 32)
                
                Spacer()
                
                Text("Pilih kategori")
                    .font(.headline.bold())
                    .foregroundStyle(.black)
                
                Spacer()
                
                Button {
                    dismiss()
                    parentSheetDismiss?()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.headline)
                        .foregroundStyle(Color.gray.opacity(0.8))
                }
                .frame(width: 32, height: 32)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            Group {
                if categoryStore.isLoading {
                    VStack {
                        Spacer()
                        ProgressView("Memuat kategori...")
                        Spacer()
                    }
                } else if let errorMessage = categoryStore.errorMessage {
                    VStack(spacing: 12) {
                        Spacer()
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.orange)
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                } else {
                    categoryListContent
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .task {
            await categoryStore.fetchCategoriesIfNeeded()
        }
    }
    
    private var categoryListContent: some View {
        List {
            Section {
                categoryRow(option: .all)
            } header: {
                Text("SEMUA KATEGORI")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Section {
                categoryRow(option: .incomeStatus(.paid))
                categoryRow(option: .incomeStatus(.dp))
                categoryRow(option: .incomeStatus(.notPaid))
            } header: {
                Text("PEMASUKAN")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Section {
                ForEach(categoryStore.categories) { expenseCategory in
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
    
    @ViewBuilder
    private func categoryRow(option: CategoryFilterOption) -> some View {
        Button {
            selectedCategory = option
            dismiss()
        } label: {
            HStack {
                Text(option.title)
                    .font(.body)
                    .foregroundStyle(.black)
                
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

#Preview {
    struct PreviewContainer: View {
        @State private var selected: CategoryFilterOption? = .incomeStatus(.paid)
        
        var body: some View {
            Text("Test Page")
                .sheet(isPresented: .constant(true)) {
                    SheetFilterCategory(selectedCategory: $selected)
                        .environmentObject(CategoryStore.shared)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
        }
    }
    
    return PreviewContainer()
}
