//
//  UpdateUserInfoUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/21/24.
//

import Foundation
import Combine

class UpdateUserInfoUseCase {
    private let settingRepo: SettingRepositoryProtocol
    
    init(settingRepo: SettingRepositoryProtocol = SettingRepository()) {
        self.settingRepo = settingRepo
    }
    
    func execute(newUserInfo: UserInfoDTO) -> AnyPublisher<UserInfoUpdateDTO, Error> {
        settingRepo.updateUserInfo(newUserInfo: newUserInfo)
    }
}
