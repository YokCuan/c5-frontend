//
//  ExpenseCategorySheetContent.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 24/08/26.
//

import SwiftUI

public struct ExpenseCategorySheetContent: View {
    @Environment(\.dismiss) private var dismiss
    
    var expenseCategories: [ExpenseCategory] = ExpenseCategory.defaults
    
    @Binding var selectedExpenseCategory: String
    
    public var body: some View {
        VStack(spacing: 16) {
            Text("Kategori Pengeluaran")
                .font(.headline.bold())
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(expenseCategories) { category in
                        Button(action: {
                            selectedExpenseCategory = category.name
                            dismiss()
                        }) {
                            VStack(spacing: 0) {
                                HStack {
                                    Text(category.name)
                                        .font(.body)
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    if selectedExpenseCategory == category.name {
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
        .padding()
        .presentationDetents([.fraction(0.55), .medium])
        .presentationDragIndicator(.visible)
        .background(Color(.systemBackground))
    }
}

#Preview {
    @Previewable @State var selected = "Listrik, Gas, Air, Sewa"
    return ExpenseCategorySheetContent(selectedExpenseCategory: $selected)
}
