//
//  PersonalInfoEditViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/7/24.
//

import Foundation
import Combine

class PersonalInfoEditViewModel {
    private var cancellable = Set<AnyCancellable>()
    weak var cooridnator: SettingCoordinator?
    
    var personalInfoItems = PersonalInfoItem.allCases
    var otherInfoItems = OtherInfoItem.allCases
    
    var errorPublisher = PassthroughSubject<Error, Never>()
    var newUserInfo = CurrentValueSubject<UserInfoDTO?, Never>(nil)
    var currentUserInfo: UserInfoDTO
    
    // usecase
//    private let getUserInfoUseCase: GetUserInfoUseCase
    
    init(cooridnator: SettingCoordinator? = nil,
         currentUserInfo: UserInfoDTO) {
        self.cooridnator = cooridnator
        self.currentUserInfo = currentUserInfo
        newUserInfo.send(currentUserInfo)
    }
}

extension PersonalInfoEditViewModel {
    enum PersonalInfoItem: Int, CaseIterable {
        case nickName,
             age,
             address,
             income,
             education,
             jobs
        
        var title: String {
            switch self {
            case .nickName:
                "닉네임"
            case .age:
                "나이"
            case .address:
                "거주지"
            case .income:
                "작년 소득"
            case .education:
                "학력"
            case .jobs:
                "직업"
            }
        }
    }
    
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
}
