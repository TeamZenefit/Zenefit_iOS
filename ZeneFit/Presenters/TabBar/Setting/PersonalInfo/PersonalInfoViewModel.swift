//
//  PersonalInfoViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/4/23.
//

import Foundation
import Combine

final class PersonalInfoViewModel {
    private var cancellable = Set<AnyCancellable>()
    weak var cooridnator: SettingCoordinator?
    
    var personalInfoItems = PersonalInfoItem.allCases
    var otherInfoItems = OtherInfoItem.allCases
    
    var errorPublisher = PassthroughSubject<Error, Never>()
    var userInfo = CurrentValueSubject<UserInfoDTO?, Never>(nil)
    
    // usecase
    private let getUserInfoUseCase: GetUserInfoUseCase
    
    init(cooridnator: SettingCoordinator? = nil,
         getUserInfoUseCase: GetUserInfoUseCase = .init()) {
        self.cooridnator = cooridnator
        self.getUserInfoUseCase = getUserInfoUseCase
        
        bind()
    }
    
    private func bind() {
        getUserInfoUseCase.execute()
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorPublisher.send(error)
                }
            }, receiveValue: { [weak self] userInfo in
                self?.userInfo.send(userInfo)
            }).store(in: &cancellable)
    }
}

extension PersonalInfoViewModel {
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
