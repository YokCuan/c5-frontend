//
//  IncomeExpenseChoiceSheet.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 24/08/26.
//

import SwiftUI

public struct IncomeExpenseChoiceSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var navigationRoute: AppRoute?
    
    public var body: some View {
        VStack(spacing: 24) {
            HStack {
                Spacer()
                Text("Pilih Tipe Transaksi")
                    .font(.headline)
                Spacer()
            }
            .padding(.top, 30)
            
            VStack(spacing: 0) {
                Button {
                    dismiss()
                    navigationRoute = .addIncome
                } label: {
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 44, height: 44)
                            Image(systemName: "arrow.down.right")
                                .font(.body.bold())
                                .foregroundStyle(.green)
                        }
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Pemasukan")
                                .font(.body.bold())
                                .foregroundStyle(.black)
                            Text("Catat penjualan baru")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                }
                
                Divider()
                
                Button {
                    dismiss()
                    navigationRoute = .addExpense
                } label: {
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.red.opacity(0.2))
                                .frame(width: 44, height: 44)
                            Image(systemName: "arrow.up.right")
                                .font(.body.bold())
                                .foregroundStyle(.red.opacity(0.8))
                        }
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Pengeluaran")
                                .font(.body.bold()).foregroundStyle(.black)
                            Text("Catat pengeluaran baru")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .presentationDetents([.fraction(0.5), .height(300)])
        .presentationDragIndicator(.visible)
        .background(Color(.systemBackground))
    }
}

#Preview {
    MainTabView()
}
