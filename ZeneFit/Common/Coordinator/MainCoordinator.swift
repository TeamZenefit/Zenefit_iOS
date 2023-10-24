//
//  MainCoordinator.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/09/28.
//

import UIKit

final class MainCoordinator {
    var childCoordinators: [Coordinator] = []
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let splashVC = SplashViewController()
        splashVC.coordinator = self
        window.rootViewController = splashVC
    }
    
    func childDidFinish(_ child: Coordinator?) {
        guard let index = childCoordinators.firstIndex(where: { $0 === child })
        else { return }
        
        childCoordinators.remove(at: index)
    }
}

extension MainCoordinator {
    func pushToLoginVC() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        
        let coordinator = AuthCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        coordinator.start()
        
        childCoordinators.append(coordinator)
    }
    
    func pushToTabbarVC() {
        window.rootViewController = setTabbarController()
    }
}

private extension MainCoordinator {
    func setTabbarController() -> MainTabbarController {
        let tabbarVC = MainTabbarController()
        let homeVC = HomeViewController()
        homeVC.tabBarItem = .init(title: "홈",
                                  image: .init(named: "HomeOff")?.withRenderingMode(.alwaysOriginal),
                                  selectedImage: .init(named: "HomeOn")?.withRenderingMode(.alwaysOriginal))
        
        let welfareVC = UINavigationController()
        let welfareCoordinator = WelfareCoordinator(tabbarController: tabbarVC,
                                                    navigationController: welfareVC)
        welfareCoordinator.parentCoordinator = self
        welfareCoordinator.start()
        childCoordinators.append(welfareCoordinator)
        welfareVC.tabBarItem = .init(title: "정책",
                                     image: .init(named: "WelfareOff")?.withRenderingMode(.alwaysOriginal),
                                     selectedImage: .init(named: "WelfareOn")?.withRenderingMode(.alwaysOriginal))
        
        let scheduleVC = ScheduleViewController()
        scheduleVC.tabBarItem = .init(title: "일정",
                                      image: .init(named: "CalendarOff")?.withRenderingMode(.alwaysOriginal),
                                      selectedImage: .init(named: "CalendarOn")?.withRenderingMode(.alwaysOriginal))
        
        let settingVC = SettingViewController()
        settingVC.tabBarItem = .init(title: "설정",
                                     image: .init(named: "SettingOff")?.withRenderingMode(.alwaysOriginal),
                                     selectedImage: .init(named: "SettingOn")?.withRenderingMode(.alwaysOriginal))
        
        tabbarVC.viewControllers = [homeVC, welfareVC, scheduleVC, settingVC]
        
        return tabbarVC
    }
}

