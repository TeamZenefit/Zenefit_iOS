//
//  WelfareCoordinator.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import UIKit

class WelfareCoordinator: Coordinator {
    weak var delegate: CoordinatorDelegate?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let welfareVM = WelfareViewModel(coordinator: self)
        let welfareVC = WelfareViewController(viewModel: welfareVM)
        navigationController.viewControllers = [welfareVC]
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
    
    func showWelfareListVC(type: WelfareType) {
        let listVM = WelfareListViewModel(coordinator: self,
                                          type: type)
        let listVC = WelfareListViewController(viewModel: listVM)
        
        navigationController.pushViewController(listVC, animated: true)
    }
}
