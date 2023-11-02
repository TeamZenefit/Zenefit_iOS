//
//  HomeCoordinator.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/29.
//

import UIKit

final class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var delegate: CoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        pushToHomeMain()
    }
}

extension HomeCoordinator {
    func pushToHomeMain() {
        let homeVM = HomeViewModel(coordinator: self)
        let homeVC = HomeViewController(viewModel: homeVM)
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    func presentToMenual() {
        navigationController.present(ManualViewController(), animated: false)
    }
    
    func pushToBookmark() {
        let bookmarkVM = BookmarkViewModel(coordinator: self)
        let bookmarkVC = BookmarkViewController(viewModel: bookmarkVM)
        navigationController.pushViewController(bookmarkVC, animated: true)
    }
    
    func pushToBenefit() {
        let benefitVM = BenefitViewModel(coordinator: self)
        let benefitVC = BenefitViewController(viewModel: benefitVM)
        navigationController.pushViewController(benefitVC, animated: true)
    }
}
