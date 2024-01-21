//
//  OtherInfoItem.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/21/24.
//

import Foundation

enum OtherInfoItem: Int, CaseIterable {
    case gender,
         isSmallCompany,
         isSoldier,
         isLowIncomeFamilies,
         isDisabledPerson,
         isLocalTalent,
         isFarmer
    
    var title: String {
        switch self {
        case .gender:
            "성별"
        case .isSmallCompany:
            "중소기업"
        case .isSoldier:
            "군인"
        case .isLowIncomeFamilies:
            "저소득층"
        case .isDisabledPerson:
            "장애인"
        case .isLocalTalent:
            "지역 인재"
        case .isFarmer:
            "농업인"
        }
    }
}
