import SwiftUI
import Foundation

public enum PaymentStatus: String, Codable {
    case paid = "paid"
    case dp = "dp_paid"
    case notPaid = "not_paid"
    
    public var title: String {
        switch self {
        case .paid: return "LUNAS"
        case .dp: return "DP"
        case .notPaid: return "BELUM DIBAYAR"
        }
    }
    
    public var watermarkText: String? {
        switch self {
        case .paid: return "LUNAS"
        case .dp: return "DP"
        case .notPaid: return "BELUM\nDIBAYAR"
        }
    }
    
    public var themeColor: Color {
        switch self {
        case .paid: return .green
        case .dp: return .orange
        case .notPaid: return .red
        }
    }
    
    public var iconName: String {
        switch self {
        case .paid: return "checkmark.circle"
        case .dp: return "clock.circle"
        case .notPaid: return "exclamationmark.circle"
        }
    }
}
