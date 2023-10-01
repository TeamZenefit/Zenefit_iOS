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
    
    var signUpViewModel = SignUpViewModel()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SignInViewModel()
        let signInVC = SignInViewController(viewModel: viewModel)
        signInVC.coordinator = self
        
        signUpViewModel = SignUpViewModel()
        let tempVC = BasicInfoInputViewController(viewModel: signUpViewModel)
        tempVC.coordinator = self
        
        navigationController.viewControllers = [tempVC]
    }
    
    func didFinishAuth() {
        parentCoordinator?.pushToTabbarVC()
        parentCoordinator?.childDidFinish(self)
    }
}

extension AuthCoordinator {
    func pushToIncomeInputVC() {
        let incomeInputVC = IncomeInputViewController(viewModel: signUpViewModel)
        incomeInputVC.coordinator = self
        navigationController.pushViewController(incomeInputVC, animated: false)
    }
    
    func pushToDetailInfoInputVC() {
        let detailInputVC = DetailInfoInputViewController(viewModel: signUpViewModel)
        detailInputVC.coordinator = self
        navigationController.pushViewController(detailInputVC, animated: false)
    }
    
    func showSelectionBottomSheet(title: String, list: [String], selectedItem: String?, completion: ((String)->Void)? = nil) {
        SelectionBottomSheet.showBottomSheet(view: navigationController.view,
                                             title: title,
                                             list: list,
                                             selectedItem: selectedItem,
                                             completion: completion)
    }
    
    func showMultiSelectionBottomSheet(title: String, list: [String], selectedItems: [String]?, completion: (([String]?)->Void)? = nil) {
        MultiSelectionBottomSheet.showBottomSheet(view: navigationController.view,
                                                  title: title,
                                                  list: list,
                                                  selectedItems: selectedItems,
                                                  completion: completion)
    }
}
