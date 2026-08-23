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
        VStack(alignment: .leading, spacing: 30) {
            Text("Kategori Pengeluaran")
                .font(.title3.bold())
            
            ScrollView {
                VStack(spacing: 25) {
                    ForEach(expenseCategories, id: \.self) { category in
                        Button(action: {
                            selectedExpenseCategory = category
                            dismiss()
                        }) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(category)
                                    .font(.body)
                                    .foregroundStyle(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                .padding(.leading)
            }
        }
        .padding()
       
    }
}

#Preview {
    ExpenseCategorySheetContent(selectedExpenseCategory: .constant("Bahan Baku"))
}
