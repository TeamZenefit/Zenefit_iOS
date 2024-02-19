//
//  Date+.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/20/24.
//

import Foundation

extension Date {
    
    /// "YYYY-MM-dd""
    var formattedString: String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY-MM-dd"
        
        return dateFormat.string(from: self)
    }
    
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
}
