//
//  PersonalInfoItem.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/21/24.
//

import Foundation

enum PersonalInfoItem: Int, CaseIterable {
    case nickName,
         age,
         area,
         city,
         income,
         education,
         jobs
    
    var title: String {
        switch self {
        case .nickName:
            "닉네임"
        case .age:
            "나이"
        case .area:
            "지역"
        case .city:
            "소속지역"
        case .income:
            "작년 소득"
        case .education:
            "학력"
        case .jobs:
            "직업"
        }
    }
}
