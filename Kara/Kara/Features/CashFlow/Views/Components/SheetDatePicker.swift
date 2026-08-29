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
    
    @State private var activeField: DateField = .start
    
    enum DateField {
        case start, end
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            HStack {
                
                Text("Atur Rentang Waktu")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                
                Spacer()
                
                Button {
                    dismiss()
                    parentSheetDismiss?()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.headline)
                        .foregroundStyle(Color.gray .opacity(0.8))
                }
            }
            
            HStack(spacing: 16) {
                dateInputCard(
                    title: "Dari",
                    dateString: dateFormatter.string(from: startDate),
                    isSelected: activeField == .start
                ) {
                    activeField = .start
                }
                
                dateInputCard(
                    title: "Ke",
                    dateString: dateFormatter.string(from: endDate),
                    isSelected: activeField == .end
                ) {
                    activeField = .end
                }
            }
            .font(.body)
            .fontWeight(.bold)
            .foregroundStyle(Color.black)
            .cornerRadius(10)
            
            Button {
                dismiss()
            } label: {
                Text("Terapkan")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 48))
            }
            
            if activeField == .start {
                DatePicker(
                    "",
                    selection: $startDate,
                    in: ...endDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
            } else {
                DatePicker(
                    "",
                    selection: $endDate,
                    in: startDate...,
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
            }
        }
        .padding(.top, 8)
        .padding()
    }
       
    
    @ViewBuilder
    private func dateInputCard(title: String, dateString: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                HStack {
                    Text(dateString)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Image(systemName: "calendar")
                        .foregroundStyle(.gray)
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

#Preview {
    SheetDatePicker(
        startDate: .constant(Date()),
        endDate: .constant(Date())
    )
}
