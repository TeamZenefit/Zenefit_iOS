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
        case welfareDetail(welfareId: Int)
    }
    
    var childCoordinators: [any Coordinator] = []
    var welfareCoordinator: WelfareCoordinator?
    var navigationController: UINavigationController
    
    weak var delegate: CoordinatorDelegate?
    let tabBarController = MainTabbarController()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var currenntNavigationController: UINavigationController? {
        let tabItem = TabBarItem.allCases[tabBarController.selectedIndex]
        switch tabItem {
        case .home:
            return childCoordinators.first(where: { $0 is HomeCoordinator })?.navigationController
        case .welfare:
            return childCoordinators.first(where: { $0 is WelfareCoordinator })?.navigationController
        case .setting:
            return childCoordinators.first(where: { $0 is SettingCoordinator })?.navigationController
        case .schedule:
            return childCoordinators.first(where: { $0 is ScheduleCoordinator })?.navigationController
        }
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
            
            tabBarController.viewControllers = items
            tabBarController.coordinator = self
            
            navigationController.present(tabBarController, animated: true)
            if isRegist,
               let welfare = childCoordinators.first(where: { $0 is WelfareCoordinator }) as? WelfareCoordinator {
                tabBarController.selectedIndex = 1
                welfare.setAction(.find)
            }
        case .welfareDetail(let welfareId):
            guard let nc = currenntNavigationController else {
                return
            }
            
            welfareCoordinator = WelfareCoordinator(navigationController: nc)
            welfareCoordinator?.setAction(.detail(id: welfareId))
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
