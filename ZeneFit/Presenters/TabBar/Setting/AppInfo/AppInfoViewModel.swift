//
//  AppInfoViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import Foundation

final class AppInfoViewModel {
    weak var coordinator: SettingCoordinator?
    
    init(coordinator: SettingCoordinator? = nil) {
        self.coordinator = coordinator
    }
}
