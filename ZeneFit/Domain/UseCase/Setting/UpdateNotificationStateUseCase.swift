//
//  UpdateNotificationStatusUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/6/24.
//

import Foundation
import Combine


struct UpdateNotificationStateUseCase {
    private let settingRepo: SettingRepositoryProtocol
    
    init(settingRepo: SettingRepositoryProtocol = SettingRepository()) {
        self.settingRepo = settingRepo
    }
    
    func execute(isAllow: Bool) -> AnyPublisher<Void, Error>{
        settingRepo.updateNotificationStatus(isAllow: isAllow)
    }
}
