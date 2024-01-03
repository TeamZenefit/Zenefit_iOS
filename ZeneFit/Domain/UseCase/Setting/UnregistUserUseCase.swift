//
//  UnregistUserUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/4/24.
//

import Foundation

struct UnregistUserUseCase {
    private let settingRepo: SettingRepositoryProtocol
    
    init(settingRepo: SettingRepositoryProtocol = SettingRepository()) {
        self.settingRepo = settingRepo
    }
    
    func execute() async throws {
        try await settingRepo.unregistUser()
    }
}
