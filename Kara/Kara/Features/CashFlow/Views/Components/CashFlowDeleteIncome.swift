//
//  CashFlowDeleteIncome.swift
//  Kara
//
//  Created by Shelly Mutiara Haq on 24/08/26.
//

import SwiftUI

struct DeleteIncome: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack (spacing : 16) {
            Image(systemName: "trash")
                .font(.title2)
                .foregroundStyle(Color.red)
                .frame(width: 40, height: 40)
                .background(Color.red.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text("Hapus Pemasukan")
                .font(.title3)
                .fontWeight(.bold)
            
            Text ("Transaksi ini akan dihapus secara permanen dan tidak dapat dibatalkan.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
            
            Button("Hapus") {
                
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.red)
            .foregroundColor(.white)
            .fontWeight(.semibold)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Button("Batalkan") {
                dismiss()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.5))
            .foregroundColor(.black)
            .fontWeight(.semibold)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
        }
        .padding(20)
    }
}


#Preview {

    DeleteIncome()

}
