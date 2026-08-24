//
//  ExpenseCategorySheetContent.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 24/08/26.
//

import SwiftUI

public struct ExpenseCategorySheetContent: View {
    @Environment(\.dismiss) private var dismiss
    
    let expenseCategories = [
        "Bahan Baku",
        "Kemasan",
        "Listrik, Gas, Air, Sewa",
        "Pengiriman",
        "Gaji Pekerja",
        "Diambil untuk Pribadi",
        "Lainnya"
    ]
    
    @Binding var selectedExpenseCategory: String
    
    public var body: some View {
        VStack(spacing: 8) {
            Text("Kategori Pengeluaran")
                .font(.headline.bold())
                .padding(.top, 24)
                .padding(.bottom, 8)
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(expenseCategories, id: \.self) { category in
                        Button(action: {
                            selectedExpenseCategory = category
                            dismiss()
                        }) {
                            VStack(spacing: 0) {
                                HStack {
                                    Text(category)
                                        .font(.body)
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    if selectedExpenseCategory == category {
                                        Image(systemName: "checkmark")
                                            .font(.body.bold())
                                            .foregroundStyle(.blue)
                                    }
                                }
                                .padding()
                                
                                Divider()
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
            }
        }
        .presentationDetents([.fraction(0.55), .medium])
        .presentationDragIndicator(.visible)
        .background(Color(.systemBackground))
    }
}

#Preview {
    @Previewable @State var selected = "Listrik, Gas, Air, Sewa"
    return ExpenseCategorySheetContent(selectedExpenseCategory: $selected)
}
