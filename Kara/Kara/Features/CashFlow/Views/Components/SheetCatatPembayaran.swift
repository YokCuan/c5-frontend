//
//  SheetCatatPembayaran.swift
//  Kara
//
//  Created by Samuel Bonardo on 25/08/26.
//

import SwiftUI

struct SheetCatatPembayaran: View {
    @State private var bayar: String = "Masukkan nominal pembayaran"
    var body: some View {
        VStack {
            Text("Catat Pembayaran")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
            
            HStack {
                Text("Bu Sherin")
                Text("· Sisa")
                Text("Rp5.000")
            }
            .font(.callout)
            .fontWeight(.regular)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
            
            Divider()
            
            Text("Jumlah Pembayaran")
                .font(.callout)
                .fontWeight(.regular)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
            
            HStack {
                Text("Rp")
                    .font(.callout)
                    .fontWeight(.regular)
                    .foregroundStyle(.secondary)
            TextField("Cari transaksi...", text: $bayar)
                .foregroundColor(Color.primary)
                .font(.title2)
                .fontWeight(.bold)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
            .background(Color.secondary.opacity(0.1))
        }
        .padding()
    }
}

#Preview {
    SheetCatatPembayaran()
}
