//
//  GetSocialInfoUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/10/23.
//

import Foundation
import Combine

class GetSocialInfoUseCase {
    private let settingRepo: SettingRepositoryProtocol
    
    init(settingRepo: SettingRepositoryProtocol = SettingRepository()) {
        self.settingRepo = settingRepo
    }
    
    func execute() -> AnyPublisher<SocialInfoDTO, Error> {
        settingRepo.getSocialInfo()
    }
}
