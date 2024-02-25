//
//  NotiDateType.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2/25/24.
//

import Foundation

enum NotiDateType: String, CaseIterable {
    case none = "NONE"
    case sttDate = "STT_DATE"
    case endDate = "END_DATE"
    
    var title: String {
        switch self {
        case .endDate: "마감일"
        case .sttDate: "시작일"
        case .none: "전체"
        }
    }
}
