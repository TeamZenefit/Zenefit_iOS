//
//  ScheduleCoordinator.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/5/24.
//

import UIKit

class ScheduleCoordinator: Coordinator {
    enum CoordinatorAction {
        case main
    }
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    var delegate: CoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        setAction(.main)
    }
    
    func setAction(_ action: CoordinatorAction) {
        switch action {
        case .main:
            let scheduleVM = ScheduleViewModel(coordinator: self)
            let scheduleVC = ScheduleViewController(viewModel: scheduleVM)
            navigationController.viewControllers = [scheduleVC]
        }
    }
}
