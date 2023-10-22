//
//  WelfareCoordinator.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import UIKit

class WelfareCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: MainCoordinator?
    var navigationController: UINavigationController
    var tabbarController: MainTabbarController
    
    init(tabbarController: MainTabbarController,
         navigationController: UINavigationController) {
        self.tabbarController = tabbarController
        self.navigationController = navigationController
    }
    
    func start() {
        let welfareVC = WelfareViewController()
        welfareVC.coordinator = self
        navigationController.viewControllers = [welfareVC]
    }
    
    func didFinish() {
        parentCoordinator?.pushToLoginVC()
        parentCoordinator?.childDidFinish(self)
    }
    
    func findWelfare() {
        let viewModel = FindWelfareViewModel()
        let findWelfareVC = FindWelfareViewController(viewModel: viewModel)
        findWelfareVC.coordinator = self
        navigationController.pushViewController(findWelfareVC, animated: false)
    }
    
    func showFindWelfareResultVC(viewModel: FindWelfareViewModel,
                                 resultType: FindWelfareResultType) {
        let resultVC = FindWelfareResultViewController(viewModel: viewModel,
                                                       resultType: resultType)
        navigationController.pushViewController(resultVC, animated: false)
    }
}
