//
//  AddIncomeView.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 25/08/26.
//

import SwiftUI

public struct IncomeItemInput: Identifiable {
    public let id = UUID()
    public var name: String = ""
    public var quantity: String = "1"
    public var price: String = ""
    
    public var subtotal: Double {
        let qty = Double(quantity) ?? 0
        let unitPrice = Double(price.replacingOccurrences(of: ".", with: "")) ?? 0
        return qty * unitPrice
    }
}

public struct AddIncomeView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var transactionDate = Date()
    @State private var dueDate = Date()
    @State private var customerName = ""
    @State private var customerPhone = ""
    @State private var items: [IncomeItemInput] = [IncomeItemInput()]
    @State private var paidAmount = ""
    
    @State private var showErrors = false
    
    private var calculatedTotal: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }
    
    private var remainingAmount: Double {
        let cleanPaid = Double(paidAmount.replacingOccurrences(of: ".", with: "")) ?? 0
        return max(0, calculatedTotal - cleanPaid)
    }
    
    private var isCustomerNameValid: Bool {
        !customerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var areItemsValid: Bool {
        guard !items.isEmpty else { return false }
        return items.allSatisfy {
            !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !$0.price.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            (Double($0.price.replacingOccurrences(of: ".", with: "")) ?? 0) > 0
        }
    }
    
    private var isPaidAmountValid: Bool {
        !paidAmount.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Text("Tambah Pemasukan")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                
                Spacer()

            }
            .padding(.vertical, 25)
            .background(
                LinearGradient(colors: [
                    Color.karaBlueDark,
                    Color.karaBlue
                ], startPoint: .top, endPoint: .bottom)
            )
            
            ScrollView {
                VStack(spacing: 12) {
                    HStack {
                        Text("Tanggal")
                        Spacer()
                        DatePicker("", selection: $transactionDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                    }
                    .padding(.leading,6)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(24)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Nama Pembeli")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField("Bu Ria", text: $customerName)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Nomor Telepon (opsional)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                               
                            }
                            TextField("08.....", text: $customerPhone)
                                .keyboardType(.phonePad)
                                .font(.body)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(24)
                    
                    if showErrors && !isCustomerNameValid {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.circle")
                            Text("Nama pembeli wajib diisi")
                            Spacer()
                        }
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.top, -8)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("DETAIL BARANG")
                            .font(.caption2.bold())
                            .foregroundStyle(.secondary)
                        
                        ForEach($items) { $item in
                            HStack{
                                VStack(spacing: 10) {
                                    HStack{
                                        TextField("Nama barang (cth. Keripik Tempe 250 g)", text: $item.name)
                                        
                                        Spacer()
                                        
                                        if items.count > 1 {
                                            Button {
                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                    items.removeAll { $0.id == item.id }
                                                }
                                            } label: {
                                                Image(systemName: "trash")
                                                    .font(.subheadline)
                                                    .foregroundStyle(.red)
                                            }
                                        }
                                    }
                                    
                                    Divider()
                                    
                                    HStack(spacing: 12) {
                                        HStack(spacing: 4) {
                                            TextField("1", text: $item.quantity)
                                                .keyboardType(.numberPad)
                                                .multilineTextAlignment(.center)
                                                .frame(width: 40)
                                            Text("pcs")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 10)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                        
                                        HStack(spacing: 4) {
                                            Text("Rp")
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                            TextField("15.000", text: $item.price)
                                                .keyboardType(.numberPad)
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                    }
                                    
                                    if items.count > 1 {
                                        Divider()
                                    }
                                }
                                
                            }
                        }
                        
                        Button {
                            items.append(IncomeItemInput())
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "plus.circle")
                                Text("Tambah Barang")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(24)
                    
                    if showErrors && !areItemsValid {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.circle")
                            Text("Nama barang dan harga wajib diisi")
                            Spacer()
                        }
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.top, -8)
                    }
                    
                    if calculatedTotal > 0 {
                        HStack {
                            Text("Total")
                                .font(.body)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(calculatedTotal.toIDR)
                                .font(.headline.bold())
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(24)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Sudah Dibayar")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        HStack(spacing: 6) {
                            Text("Rp")
                                .foregroundStyle(.secondary)
                            TextField("15.000", text: $paidAmount)
                                .font(.title3.bold())
                                .keyboardType(.numberPad)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(24)
                    
                    if showErrors && !isPaidAmountValid {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.circle")
                            Text("Jumlah yang dibayar wajib diisi")
                            Spacer()
                        }
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.top, -8)
                    }
                    
                    if remainingAmount > 0 && !paidAmount.isEmpty {
                        VStack{
                            HStack {
                                Text("Sisa Pembayaran")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(remainingAmount.toIDR)
                                    .bold()
                                    .foregroundStyle(.red)
                            }
                            HStack (alignment: .center) {
                                Text("Status")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                
                                if remainingAmount == calculatedTotal{
                                    Text("Belum Bayar")
                                        .foregroundStyle(.white)
                                        .padding(.vertical,4)
                                        .padding(.horizontal,10)
                                        .background(.red)
                                        .cornerRadius(30)
                                } else{
                                    Text("DP")
                                        .foregroundStyle(.white)
                                        .padding(.vertical,4)
                                        .padding(.horizontal,10)
                                        .background(.orange)
                                        .cornerRadius(30)
                                }
                            }
                            Divider()
                            
                            HStack (alignment: .center) {
                                Text("Jatuh Tempo")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                DatePicker(
                                    "",
                                    selection: $dueDate,
                                    displayedComponents: .date
                                )
                                    .datePickerStyle(.compact)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(24)
                    }
                        
                    
                    Button {
                        if isCustomerNameValid && areItemsValid && isPaidAmountValid {
                            dismiss()
                        } else {
                            showErrors = true
                        }
                    } label: {
                        Text("Simpan")
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(24)
                    }
                    
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    AddIncomeView()
}
