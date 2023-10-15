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
        // TODO: Tabbar 화면 이동
    }
}
