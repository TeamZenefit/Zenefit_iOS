//
//  String+.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/03.
//

import Foundation

extension String {
    func trimmingPrefix(_ prefix: String) -> String {
        var result = self
        while result.hasPrefix(prefix) {
            result.removeFirst(prefix.count)
        }
        return result
    }
    
    var isNumeric: Bool {
        let numericPattern = "^[0-9]+$"
        
        if self.range(of: numericPattern, options: .regularExpression) != nil {
            return true
        } else {
            return false
        }
    }
    
    var formatCurreny: String {
        guard let amount = Int(self) else { return "" }
        
        let billion = amount / 10000
        let million = (amount % 10000)
        
        var formattedString = ""
        
        if billion > 0 {
            formattedString += "\(billion)억 "
        }
        
        if million > 0 {
            formattedString += "\(million)"
        }
        
        return formattedString.isEmpty ? "" : formattedString
    }
}
