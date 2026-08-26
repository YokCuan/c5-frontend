//
//  SearchBarFilterButton.swift
//  Kara
//
//  Created by Samuel Bonardo on 24/08/26.
//

import SwiftUI

struct SearchBarFilterButton: View {
    @ObservedObject var viewModel: CashFlowViewModel
    
    @State private var isShowingFilterSheet = false
    @State private var text: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.4))
                    
                    TextField(
                        "",
                        text: $text,
                        prompt: Text("Cari transaksi...").foregroundColor(Color.white.opacity(0.4))
                    )
                    .foregroundStyle(.white)
                    .font(.subheadline)
                }
                .padding(.horizontal, 14)
                .frame(height: 48)
                .background(Color.white.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                
                Button {
                    isShowingFilterSheet = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color(red: 0.05, green: 0.22, blue: 0.38))
                        .frame(width: 48, height: 48)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            
            HStack {
                Button {
                    viewModel.previousMonth()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.7))
                        .frame(width: 36, height: 36)
                        .background(Color.white.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Spacer()
                
                Text(viewModel.selectedMonthYearString)
                    .font(.headline.bold())
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button {
                    viewModel.nextMonth()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.7))
                        .frame(width: 36, height: 36)
                        .background(Color.white.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .sheet(isPresented: $isShowingFilterSheet) {
            FilterSheetView(
                selectedPaymentStatus: .constant(nil),
                startDate: $viewModel.startDate,
                endDate: $viewModel.endDate,
                viewModel: viewModel
            )
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.05, green: 0.22, blue: 0.38)
            .ignoresSafeArea()
        SearchBarFilterButton(viewModel: CashFlowViewModel())
    }
}
