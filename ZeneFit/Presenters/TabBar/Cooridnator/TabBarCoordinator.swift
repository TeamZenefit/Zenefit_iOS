//
//  TabBarCoordinator.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/29.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    
    enum CoordinatorAction {
        case tabBar(isRegist: Bool)
    }
    
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    
    weak var delegate: CoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        setAction(.tabBar(isRegist: false))
    }
    
    func setAction(_ action: CoordinatorAction) {
        switch action {
        case .tabBar(let isRegist):
            let items = TabBarItem.allCases.map {
                createNavigationController(item: $0)
            }
            
            let tabBarController = MainTabbarController()
            tabBarController.viewControllers = items
            tabBarController.coordinator = self
            
            navigationController.present(tabBarController, animated: true)
            if let welfare = tabBarController.coordinator?.childCoordinators.first(
                where: { $0 is WelfareCoordinator }) as? WelfareCoordinator,
               isRegist {
                tabBarController.selectedIndex = 1
                welfare.setAction(.find)
            }
            
            
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
        case .schedule:
            let scheduleCoordinator = ScheduleCoordinator(navigationController: nc)
            scheduleCoordinator.delegate = self
            scheduleCoordinator.start()
            childCoordinators.append(scheduleCoordinator)
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
