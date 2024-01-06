//
//  WelfareCoordinator.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import UIKit

class WelfareCoordinator: Coordinator {
    
    enum CoordinatorAction {
        case welfare,
             find,
             findResult(viewModel: FindWelfareViewModel,
                        resultType: FindWelfareResultType),
             list(type: SupportPolicyType),
             detail(id: Int),
             notiList
    }
    
    weak var delegate: CoordinatorDelegate?
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        setAction(.welfare)
    }
    
    func setAction(_ action: CoordinatorAction) {
        switch action {
        case .welfare:
            let welfareVM = WelfareViewModel(coordinator: self)
            let welfareVC = WelfareViewController(viewModel: welfareVM)
            navigationController.viewControllers = [welfareVC]
        case .find:
            let viewModel = FindWelfareViewModel()
            let findWelfareVC = FindWelfareViewController(viewModel: viewModel)
            findWelfareVC.coordinator = self
            navigationController.pushViewController(findWelfareVC, animated: false)
        case .findResult(let viewModel, let resultType):
            let resultVC = FindWelfareResultViewController(viewModel: viewModel,
                                                           resultType: resultType)
            navigationController.pushViewController(resultVC, animated: false)
        case .list(let type):
            let listVM = WelfareListViewModel(coordinator: self,
                                              type: type)
            let listVC = WelfareListViewController(viewModel: listVM)
            
            navigationController.pushViewController(listVC, animated: true)
        case .detail(let id):
            let detailVM = WelfareDetailViewModel(coordinator: self,
                                                  policyId: id)
            let detailVC = WelfareDetailViewController(viewModel: detailVM)
            navigationController.pushViewController(detailVC, animated: true)
        case .notiList:
            let notiCoordinator = NotificationCoordinator(navigationController: navigationController)
            notiCoordinator.delegate = self
            notiCoordinator.setAction(.notiList)
        }
    }
}

extension WelfareCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: any Coordinator) {
        if childCoordinator is NotificationCoordinator {
            let newVC = navigationController.viewControllers.filter {
                !($0 is NotiViewController || $0 is NotiSettingViewController)
            }
            navigationController.setViewControllers(newVC, animated: true)
        }
    }
}
