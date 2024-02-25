//
//  Utils.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2/12/24.
//

import UIKit

class Utils {
    static func openExternalLink(urlStr: String, _ handler:(() -> Void)? = nil) {
        guard let url = URL(string: urlStr) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:]) { (result) in
                handler?()
            }
            
        } else {
            UIApplication.shared.openURL(url)
            handler?()
        }
    }
    
    static func formattedWon(_ benefit: Int) -> String {
        var benefit = benefit
        let milion = benefit / 100_000_000
        
        benefit %= 100_000_000
        
        let tenThousand = benefit / 10_000
        
        benefit %= 10_000
        
        let thousand = benefit / 1_000
        
        var result = ""
        if milion > 0 { result += "\(milion)억" }
        if tenThousand > 0 { result += " \(tenThousand)만" }
        if thousand > 0 { result += " \(thousand)천"}
        if result.isNotEmpty { result += "원" }
        return result.trimmingPrefix(" ")
    }
}
