//
//  GetUserInfoUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/10/23.
//

import Foundation
import Combine

class GetUserInfoUseCase {
    private let settingRepo: SettingRepositoryProtocol
    
    init(settingRepo: SettingRepositoryProtocol = SettingRepository()) {
        self.settingRepo = settingRepo
    }
    
    func execute() -> AnyPublisher<UserInfoDTO, Error> {
        settingRepo.getUserInfo()
    }
}
