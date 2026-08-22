import Foundation

public enum PaymentStatus: String, CaseIterable, Codable, Equatable, Sendable {
    case lunas = "lunas"
    case dp = "dp"
    case belumBayar = "belum_bayar"
    
    public var displayName: String {
        switch self {
        case .lunas: return "Lunas"
        case .dp: return "DP"
        case .belumBayar: return "Belum Bayar"
        }
    }
}
