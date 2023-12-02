//
//  SettingCoordinator.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/29.
//

import UIKit

final class SettingCoordinator: Coordinator {
    enum CoordinatorAction {
        case main,
             appInfo
    }
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    weak var delegate: CoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        setAction(.main)
    }
    
    func setAction(_ action: CoordinatorAction) {
        switch action {
        case .main:
            let settingVM = SettingViewModel(coordinator: self)
            let settingVC = SettingViewController(viewModel: settingVM)
            navigationController.viewControllers = [settingVC]
        case .appInfo:
            let appInfoVM = AppInfoViewModel(coordinator: self)
            let appInfoVC = AppInfoViewController(viewModel: appInfoVM)
            navigationController.pushViewController(appInfoVC, animated: true)
        }
    }
}
