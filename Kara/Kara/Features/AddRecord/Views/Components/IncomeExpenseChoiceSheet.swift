//
//  IncomeExpenseChoiceSheet.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 24/08/26.
//

import SwiftUI

public struct IncomeExpenseChoiceSheet: View {
    @Environment(\.dismiss) private var dismiss
//    @Binding var navigationRoute: AppRoute?
    
    public var body: some View {
        VStack(spacing: 24) {
            ZStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.black)
                            .frame(width: 44, height: 44)
                            .background(Color(.systemGray5))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                
                Text("Pilih Tipe Transaksi")
                    .font(.headline)
            }
            .padding(.top)
            .padding(.horizontal)
            
            VStack(spacing: 0) {
                Button {
                    dismiss()
//                    navigationRoute = .addIncome
                } label: {
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 44, height: 44)
                            Image(systemName: "arrow.down")
                                .font(.body.bold())
                                .foregroundStyle(.green)
                        }
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Pemasukan")
                                .font(.body.bold())
                                .foregroundStyle(.black)
                            Text("Catat pemasukan baru")
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
//                    navigationRoute = .addExpense
                } label: {
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.red.opacity(0.2))
                                .frame(width: 44, height: 44)
                            Image(systemName: "arrow.up")
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
        .presentationDetents([.fraction(0.35), .height(260)])
        .presentationDragIndicator(.visible)
        .background(Color(.systemBackground))
    }
}

#Preview {
    IncomeExpenseChoiceSheet()
}
