//
//  FormatExtensions.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 24/08/26.
//

import Foundation

public extension Double {
    var toIDR: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "Rp0"
    }
}

public extension Date {
    func formattedDate(format: String = "d MMMM yyyy") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func formattedTime(format: String = "HH:mm") -> String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "id_ID")
            formatter.dateFormat = format
            return formatter.string(from: self)
        }
    
}

public extension String {
    var formattedWithSeparator: String {
        let numbersOnly = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        guard let number = Int(numbersOnly) else { return self }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "id_ID") 
        
        return formatter.string(from: NSNumber(value: number)) ?? self
    }
}
