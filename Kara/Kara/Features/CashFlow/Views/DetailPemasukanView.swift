//
//  DetailPemasukanView.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 23/08/26.
//

import SwiftUI

public struct DetailPemasukanView: View {
    public var body: some View {
        VStack(spacing: 20) {
            //Catd
            VStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.green)
                    .frame(height: 4)
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bu Ria")
                            .font(.title3.bold())
                        Text("Penjualan")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("JUMLAH DITERIMA")
                            .font(.caption2.bold())
                            .foregroundStyle(.gray)
                        Text("+ Rp50.000")
                            .font(.title.bold())
                            .foregroundStyle(.green)
                    }
                    
                    Divider()
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("Waktu")
                                .foregroundStyle(.gray)
                            Spacer()
                            Text("18:00")
                                .bold()
                        }
                        HStack {
                            Text("Tanggal")
                                .foregroundStyle(.gray)
                            Spacer()
                            Text("17 Agustus 2026")
                                .bold()
                        }
                    }
                }
                .padding()
            }
            .background(.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.05), radius: 5, y: 4)
            
            //Warning
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.circle")
                Text("Pemasukan dari penjualan tidak bisa diedit. Ubah data di halaman Penjualan")
                Spacer()
            }
            .font(.footnote)
            .foregroundStyle(.blue)
            .padding(15)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            
            
            //DelButton
            Button(action: {}) {
                Text("Hapus Pemasukan")
                    .font(.body.bold())
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Detail Pemasukan")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        DetailPemasukanView()
    }
}
