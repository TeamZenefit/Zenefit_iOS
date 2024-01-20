//
//  ScheduleCoordinator.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/5/24.
//

import UIKit

class ScheduleCoordinator: Coordinator {
    enum CoordinatorAction {
        case main, notiList, welfareDetail(policyId: Int)
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
            navigationController.setViewControllers([scheduleVC], animated: false)
        case .notiList:
            let notiCoordinator = NotificationCoordinator(navigationController: navigationController)
            notiCoordinator.delegate = self
            notiCoordinator.setAction(.notiList)
            childCoordinators.append(notiCoordinator)
        case .welfareDetail(let welfareId):
            let welfareCoordinator = WelfareCoordinator(navigationController: navigationController)
            childCoordinators.append(welfareCoordinator)
            welfareCoordinator.delegate = self
            welfareCoordinator.setAction(.detail(id: welfareId))
        }
    }
}

extension ScheduleCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: any Coordinator) {
        if childCoordinator is NotificationCoordinator {
            if !navigationController.viewControllers.contains(where: {
                ($0 is NotiViewController || $0 is NotiSettingViewController)
            }) {
                childCoordinators.removeAll(where: { $0 is NotificationCoordinator })
            }
        } else {
            childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
        }
    }
}
