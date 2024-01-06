//
//  HomeCoordinator.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/29.
//

import UIKit

final class HomeCoordinator: Coordinator {
    
    enum CoordinatorAction {
        case home, menual, bookmark, benefit, welfareDetail(welfareId: Int), notiList
    }
    
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    var delegate: CoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        setAction(.home)
    }
    
    func setAction(_ action: CoordinatorAction) {
        switch action {
        case .home:
            let homeVM = HomeViewModel(coordinator: self)
            let homeVC = HomeViewController(viewModel: homeVM)
            navigationController.pushViewController(homeVC, animated: true)
        case .menual:
            navigationController.present(ManualViewController(), animated: false)
        case .bookmark:
            let bookmarkVM = BookmarkViewModel(coordinator: self)
            let bookmarkVC = BookmarkViewController(viewModel: bookmarkVM)
            navigationController.pushViewController(bookmarkVC, animated: true)
        case .benefit:
            let benefitVM = BenefitViewModel(coordinator: self)
            let benefitVC = BenefitViewController(viewModel: benefitVM)
            navigationController.pushViewController(benefitVC, animated: true)
        case .welfareDetail(let welfareId):
            let welfareCoordinator = WelfareCoordinator(navigationController: navigationController)
            childCoordinators.append(welfareCoordinator)
            welfareCoordinator.delegate = self
            welfareCoordinator.setAction(.detail(id: welfareId))
        case .notiList:
            let notiCoordinator = NotificationCoordinator(navigationController: navigationController)
            notiCoordinator.delegate = self
            notiCoordinator.setAction(.notiList)
        }
    }
}

extension HomeCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: any Coordinator) {
        if childCoordinator is NotificationCoordinator {
            let newVC = navigationController.viewControllers.filter {
                !($0 is NotiViewController || $0 is NotiSettingViewController)
            }
            navigationController.setViewControllers(newVC, animated: true)
        } else if let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
