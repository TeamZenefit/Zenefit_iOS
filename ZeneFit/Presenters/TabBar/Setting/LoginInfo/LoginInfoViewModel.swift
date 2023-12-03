//
//  LoginInfoViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import Foundation

final class LoginInfoViewModel {
    let coordinator: SettingCoordinator?
    
    init(coordinator: SettingCoordinator?) {
        self.coordinator = coordinator
    }
    
    func logout() {
        KeychainManager.delete(key: "accessToken")
        KeychainManager.delete(key: "refreshToken")
        coordinator?.finish()
    }
}
