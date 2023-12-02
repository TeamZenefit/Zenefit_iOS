//
//  MainCoordinator.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/09/28.
//

import UIKit
import Combine

final class MainCoordinator: Coordinator {
    
    enum CoordinatorAction {
        case auth, tabBar, registComplete
    }
    
    var childCoordinators: [ any Coordinator] = []
    var navigationController: UINavigationController
    
    weak var delegate: CoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let splashVC = SplashViewController()
        splashVC.coordinator = self
        navigationController.setViewControllers([splashVC], animated: false)
    }
    
    func setAction(_ action: CoordinatorAction) {
        switch action {
        case .auth:
            let authCoordinator = AuthCoordinator(navigationController: navigationController)
            authCoordinator.delegate = self
            authCoordinator.mainCoordinator = self
            authCoordinator.start()
            childCoordinators.append(authCoordinator)
        case .tabBar:
            let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
            tabBarCoordinator.delegate = self
            tabBarCoordinator.start()
            childCoordinators.append(tabBarCoordinator)
        case .registComplete:
            childCoordinators = []
            let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
            tabBarCoordinator.delegate = self
            tabBarCoordinator.setAction(.tabBar(isRegist: true))
            childCoordinators.append(tabBarCoordinator)
        }
    }
}

extension MainCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: any Coordinator) {
        childCoordinators = []
        if childCoordinator is AuthCoordinator {
            setAction(.tabBar)
        } else {
            setAction(.auth)
        }
    }
}


