//
//  WelfareSortType.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/31/23.
//

import Foundation

enum WelfareSortType: String {
    case applyEndDate
    case benefit
    
    var description: String {
        switch self {
        case .benefit: "수혜금액"
        case .applyEndDate: "마감순"
        }
    }
}
