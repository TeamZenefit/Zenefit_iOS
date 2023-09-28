//
//  AuthCoordinator.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/09/28.
//

import UIKit

final class AuthCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: MainCoordinator?
    var navigationController: UINavigationController
    var window: UIWindow
    
    init(navigationController: UINavigationController,
         window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
    }
    
    func start() {
        let viewModel = SignInViewModel()
        let signInVC = SignInViewController(viewModel: viewModel)
        signInVC.coordinator = self
        
        window.rootViewController = signInVC
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
    }
    
    func didFinishAuth() {
        parentCoordinator?.pushToTabbarVC()
        parentCoordinator?.childDidFinish(self)
    }
}
