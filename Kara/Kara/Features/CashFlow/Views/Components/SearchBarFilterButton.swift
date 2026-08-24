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
    
    var body: some View {
        // Filter Section
        VStack(spacing: 16) {
            // Top Row: Search Bar + Filter Button
            HStack(spacing: 12) {
                // Search TextField
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary.opacity(0.6))
                    TextField("Cari transaksi...", text: $viewModel.searchText)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background (.primary.opacity(0.12))
                .cornerRadius(10)
                
                // Filter Button
                Button {
                    isShowingFilterSheet = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                }
            }
            
            // Bottom Row: Month Navigator
            HStack {
                Button {
                    // Logic to go to previous month
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(Color(UIColor.secondarySystemBackground)
                            .cornerRadius(8))
                }
                
                Spacer()
                
                Text("Agustus 2026")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button {
                    // Logic to go to next month
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(Color(UIColor.secondarySystemBackground)
                            .cornerRadius(8))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
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
