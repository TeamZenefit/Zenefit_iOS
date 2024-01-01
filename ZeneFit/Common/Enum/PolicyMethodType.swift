//
//  PolicyMethodType.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/1/24.
//

import Foundation

enum PolicyMethodType: String {
    case online = "ONLINE"
    case letter = "LETTER"
    case visit = "VISIT"
    case blank = "BLANK"
    
    var description: String {
        switch self {
        case .online: return "온라인 신청"
        case .letter: return "우편 신청"
        case .visit: return "방문 신청"
        case .blank: return "알 수 없음"
        }
    }
}
