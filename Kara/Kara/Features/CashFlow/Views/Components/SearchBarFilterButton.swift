//
//  SearchBarFilterButton.swift
//  Kara
//
//  Created by Samuel Bonardo on 24/08/26.
//

import SwiftUI
import Combine

// 2. Your component
struct SearchBarFilterButton: View {
    @ObservedObject var viewModel: CashFlowViewModel
    
    @State private var isShowingFilterSheet = false
    @State private var text: String = ""
    
    var body: some View {
        // Filter Section
        VStack(spacing: 8) {
            // Top Row: Search Bar + Filter Button
            HStack(spacing: 8) {
                // Search TextField
                HStack {
                    Image(systemName: "magnifyingglass")
                    if text.isEmpty {
                        Text("Cari transaksi...")
                            .foregroundColor(Color(UIColor.secondarySystemBackground))
                    }
                    
                    // TextField Utama
                    TextField("", text: $text)
                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                }
                .foregroundColor(Color(UIColor.secondarySystemBackground))
                .padding(.horizontal)
                .padding(.vertical)
                .background (.tertiary)
                .cornerRadius(16)
                
                // Filter Button
                Button {
                    isShowingFilterSheet = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .frame(width: 50, height: 50)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(16)
                }
            }
            
            // Bottom Row: Month Navigator
            HStack {
                Button {
                    viewModel.previousMonth()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(Color(UIColor.secondarySystemBackground).cornerRadius(8))
                }
                
                Spacer()
                
                Text(viewModel.selectedMonthYearString)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                
                
                Spacer()
                
                Button {
                    viewModel.nextMonth()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(Color(UIColor.secondarySystemBackground).cornerRadius(8))
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical)
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
    SearchBarFilterButton(viewModel: CashFlowViewModel())
}
