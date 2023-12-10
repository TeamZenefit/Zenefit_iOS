//
//  PersonalInfoViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/4/23.
//

import Foundation

final class PersonalInfoViewModel {
    weak var cooridnator: SettingCoordinator?
    
    var personalInfoItems = PersonalInfoItem.allCases
    var otherInfoItems = OtherInfoItem.allCases
    
    init(cooridnator: SettingCoordinator? = nil) {
        self.cooridnator = cooridnator
    }
}

extension PersonalInfoViewModel {
    enum PersonalInfoItem: String, CaseIterable {
        case nickName = "닉네임",
             age = "나이",
             address = "거주지",
             income = "작년 소득",
             education = "학력",
             jobs = "직업"
    }
    
    enum OtherInfoItem: String, CaseIterable {
        case gender = "성별",
             isSmallCompany = "중소기업",
             isSoldier = "군인",
             isLowIncomeFamilies = "저소득층",
             isDisabledPerson = "장애인",
             isLocalTalent = "지역 인재",
             isFarmer = "농업인"
    }
}
