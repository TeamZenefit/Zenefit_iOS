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
    }
    
    func fetchUserInfo() {
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
