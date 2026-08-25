//
//  SheetDatePicker.swift
//  Kara
//
//  Created by Samuel Bonardo on 25/08/26.
//

import SwiftUI

struct SheetDatePicker: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    var parentSheetDismiss: (() -> Void)? = nil
    
    @Environment(\.dismiss) private var dismiss
    
    // State lokal untuk memilih input "Dari" atau "Ke" yang sedang aktif
    @State private var activeField: DateField = .start
    
    enum DateField {
        case start, end
    }
    
    // Formatter untuk menampilkan tanggal (contoh: 19 Agu 2026)
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            // MARK: - Custom Header
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                }
                
                Text("Atur Rentang Waktu")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .padding(.leading)
                
                Spacer()
                
                Button {
                    dismiss()
                    parentSheetDismiss?()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // MARK: - Input Box (Dari & Ke)
            HStack(spacing: 12) {
                // Card "Dari"
                dateInputCard(
                    title: "Dari",
                    dateString: dateFormatter.string(from: startDate),
                    isSelected: activeField == .start
                ) {
                    activeField = .start
                }
                
                // Card "Ke"
                dateInputCard(
                    title: "Ke",
                    dateString: dateFormatter.string(from: endDate),
                    isSelected: activeField == .end
                ) {
                    activeField = .end
                }
            }
            .padding(.horizontal)
            
            // MARK: - Tombol Pasang
            Button {
                dismiss()
            } label: {
                Text("Terapkan")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
            
            // MARK: - DatePicker Wheel Native
            if activeField == .start {
                DatePicker("", selection: $startDate, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
            } else {
                DatePicker("", selection: $endDate, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
            }
            
            Spacer()
        }
    }
    
    // MARK: - Helper Subview Input Card
    @ViewBuilder
    private func dateInputCard(title: String, dateString: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                HStack {
                    Text(dateString)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "calendar")
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    SheetDatePicker(
        startDate: .constant(Date()),
        endDate: .constant(Date())
    )
}
