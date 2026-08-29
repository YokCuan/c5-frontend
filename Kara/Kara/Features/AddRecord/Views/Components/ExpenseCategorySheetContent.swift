//
//  ExpenseCategorySheetContent.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 24/08/26.
//

import SwiftUI

public struct ExpenseCategorySheetContent: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var categoryStore: CategoryStore
    
    @Binding var selectedExpenseCategoryId: UUID?
    
    public init(selectedExpenseCategoryId: Binding<UUID?>) {
        self._selectedExpenseCategoryId = selectedExpenseCategoryId
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Text("Kategori Pengeluaran")
                .font(.headline.bold())
            
            Group {
                if categoryStore.isLoading {
                    ProgressView("Memuat kategori...")
                        .frame(maxHeight: .infinity)
                } else if let errorMessage = categoryStore.errorMessage {
                    VStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    categoryList
                }
            }
        }
        .padding()
        .padding(.top, 10)
        .presentationDetents([.fraction(0.55), .medium])
        .presentationDragIndicator(.visible)
        .background(Color(.systemBackground))
        .task {
            await categoryStore.fetchCategoriesIfNeeded()
        }
    }
    
    private var categoryList: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(categoryStore.categories) { category in
                    Button(action: {
                        selectedExpenseCategoryId = category.id
                        dismiss()
                    }) {
                        VStack(spacing: 0) {
                            HStack {
                                Text(category.name)
                                    .font(.body)
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                if selectedExpenseCategoryId == category.id {
                                    Image(systemName: "checkmark")
                                        .font(.body.bold())
                                        .foregroundStyle(.blue)
                                }
                            }
                            .padding(.vertical)
                            
                            Divider()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedId: UUID? = UUID()
    return ExpenseCategorySheetContent(selectedExpenseCategoryId: $selectedId)
        .environmentObject(CategoryStore.shared)
}
