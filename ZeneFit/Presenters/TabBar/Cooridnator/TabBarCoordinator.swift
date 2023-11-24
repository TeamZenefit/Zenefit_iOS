//
//  TabBarCoordinator.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/29.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    
    enum CoordinatorAction {
        case tabBar
    }
    
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    
    weak var delegate: CoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        setAction(.tabBar)
    }
    
    func setAction(_ action: CoordinatorAction) {
        switch action {
        case .tabBar:
            let items = TabBarItem.allCases.map {
                createNavigationController(item: $0)
            }
            
            let tabBarController = MainTabbarController()
            tabBarController.viewControllers = items
            tabBarController.coordinator = self
            
            navigationController.present(tabBarController, animated: true)
        }
    }
}

private extension TabBarCoordinator {
    func createNavigationController(item: TabBarItem) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.tabBarItem = item.item
        configureTabBarCoordinator(item: item, navigationController: navigationController)
        return navigationController
    }
    
    func configureTabBarCoordinator(item: TabBarItem, navigationController nc: UINavigationController) {
        switch item {
        case .home:
            let homeCoordinator = HomeCoordinator(navigationController: nc)
            homeCoordinator.delegate = self
            homeCoordinator.start()
            childCoordinators.append(homeCoordinator)
        case .schedule: break
        case .welfare:
            let welfareCoordinator = WelfareCoordinator(navigationController: nc)
            welfareCoordinator.delegate = self
            welfareCoordinator.start()
            childCoordinators.append(welfareCoordinator)
        case .setting:
            let settingCoordinator = SettingCoordinator(navigationController: nc)
            settingCoordinator.delegate = self
            settingCoordinator.start()
            childCoordinators.append(settingCoordinator)
        }
    }
}

extension TabBarCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: any Coordinator) {
        childCoordinators = []
        finish()
        self.navigationController.dismiss(animated: true)
    }
}
