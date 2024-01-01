//
//  PolicyDateType.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/1/24.
//

import UIKit

enum PolicyDateType: String {
    case period = "PERIOD"
    case constant = "CONSTANT"
    case undecided = "UNDECIDED"
    case blank = "BLANK"
    
    var description: String {
        switch self {
        case .period: "기간 신청"
        case .constant: "상시 신청"
        case .undecided: "미정"
        case .blank: "알 수 없음"
        }
    }
}
