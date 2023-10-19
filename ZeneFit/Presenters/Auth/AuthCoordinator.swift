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
    
    var registInfoInputViewModel = RegistInfoInputViewModel()
    var agreementViewModel = AgreementViewModel()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SignInViewModel()
        let signInVC = SignInViewController(viewModel: viewModel)
        signInVC.coordinator = self
        
        navigationController.viewControllers = [signInVC]
    }
    
    func didFinishAuth() {
        parentCoordinator?.pushToTabbarVC()
        parentCoordinator?.childDidFinish(self)
    }
}

extension AuthCoordinator {
    func showAgreementVC() {
        agreementViewModel = AgreementViewModel()
        agreementViewModel.signUpInfo = registInfoInputViewModel.signUpInfo
        let agreementVC = AgreementViewController(viewModel: agreementViewModel)
        agreementViewModel.coordinator = self
        navigationController.pushViewController(agreementVC, animated: false)
    }
    
    func showRegistVC(userId: String? = nil) {
        registInfoInputViewModel = RegistInfoInputViewModel()
        registInfoInputViewModel.signUpInfo.userId = userId
        let registVC = RegistInfoInputViewController(viewModel: registInfoInputViewModel)
        registVC.coordinator = self
        navigationController.pushViewController(registVC, animated: false)
    }
    
    func showRegistCompleteVC(userName: String) {
        let completeVC = RegistCompleteViewController(userName: userName)
        completeVC.coordinator = self
        navigationController.pushViewController(completeVC, animated: false)
    }
    
    func showSelectionBottomSheet(title: String, list: [String], selectedItem: String?, completion: ((String?)->Void)? = nil) {
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
