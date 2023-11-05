//
//  SettingViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/29.
//

import Foundation

final class SettingViewModel {
    weak var coordinator: SettingCoordinator?
    
    init(coordinator: SettingCoordinator? = nil) {
        self.coordinator = coordinator
    }
    
    func logout() {
        KeychainManager.delete(key: "accessToken")
        KeychainManager.delete(key: "refreshToken")
        coordinator?.finish()
    }
}
