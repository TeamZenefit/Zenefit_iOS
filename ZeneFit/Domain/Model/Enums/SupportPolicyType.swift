//
//  SupportPolicyType.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/20/23.
//

import Foundation

enum SupportPolicyType: String, Equatable {
    case money = "MONEY"
    case loans = "LOANS"
    case social = "SOCIAL_SERVICE"
    
    var description: String {
        switch self {
        case .money: "현금 정책"
        case .loans: "대출 정책"
        case .social: "사회 서비스"
        }
    }
}
