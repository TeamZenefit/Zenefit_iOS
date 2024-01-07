//
//  GetAgreementInfoUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/7/24.
//

import Foundation
import Combine

struct GetAgreementInfoUseCase {
    private let settingRepo: SettingRepositoryProtocol
    
    init(settingRepo: SettingRepositoryProtocol = SettingRepository()) {
        self.settingRepo = settingRepo
    }
    
    func execute() -> AnyPublisher<AgreementInfoDTO, Error> {
        settingRepo.getAgreementInfo()
    }
}
