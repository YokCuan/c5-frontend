import Foundation

public enum TransactionType: String, CaseIterable, Codable, Equatable, Sendable {
    case pemasukan = "pemasukan"
    case pengeluaran = "pengeluaran"
}
