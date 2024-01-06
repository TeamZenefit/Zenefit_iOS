//
//  NotificationCoordinator.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/7/24.
//

import UIKit

class NotificationCoordinator: Coordinator {
    enum CoordinatorAction {
        case notiList
        case notiSetting
    }
    
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    
    weak var delegate: CoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    func setAction(_ action: CoordinatorAction) {
        switch action {
        case .notiList:
            let notiListVM = NotiViewModel(coordinator: self)
            let notiListVC = NotiViewController(viewModel: notiListVM)
            navigationController.pushViewController(notiListVC, animated: true)
        case .notiSetting:
            let notiSettingVM = NotiSettingViewModel(coordinator: self)
            let notiSettingVC = NotiSettingViewController(viewModel: notiSettingVM)
            navigationController.pushViewController(notiSettingVC, animated: true)
        }
    }
}
