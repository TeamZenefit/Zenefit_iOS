//
//  SettingCoordinator.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/29.
//

import UIKit

final class SettingCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    weak var delegate: CoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        pushToSettingMain()
    }
    
    func pushToSettingMain() {
        let settingVM = SettingViewModel(coordinator: self)
        let settingVC = SettingViewController(viewModel: settingVM)
        navigationController.viewControllers = [settingVC]
    }
}
