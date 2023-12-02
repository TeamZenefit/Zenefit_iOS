//
//  AuthCoordinator.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/09/28.
//

import UIKit

final class AuthCoordinator: Coordinator {
    
    enum CoordinatorAction {
        case signIn,
             signUp(userId: String?),
             signUpComplete(userName: String),
             agreement,
             findWelfare
    }
    
    weak var delegate: CoordinatorDelegate?
    weak var mainCoordinator: MainCoordinator?
    
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    
    var registInfoInputViewModel = RegistInfoInputViewModel()
    var agreementViewModel = AgreementViewModel()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        setAction(.signIn)
    }
    
    func setAction(_ action: CoordinatorAction) {
        switch action {
        case .signIn:
            let viewModel = SignInViewModel()
            let signInVC = SignInViewController(viewModel: viewModel)
            signInVC.coordinator = self
            
            navigationController.viewControllers = [signInVC]
        case .signUp(let userId):
            registInfoInputViewModel = RegistInfoInputViewModel()
            registInfoInputViewModel.signUpInfo.userId = userId
            let registVC = RegistInfoInputViewController(viewModel: registInfoInputViewModel)
            registVC.coordinator = self
            navigationController.pushViewController(registVC, animated: false)
        case .signUpComplete(let userName):
            let completeVC = RegistCompleteViewController(userName: userName)
            completeVC.coordinator = self
            navigationController.pushViewController(completeVC, animated: false)
        case .agreement:
            agreementViewModel = AgreementViewModel()
            agreementViewModel.signUpInfo = registInfoInputViewModel.signUpInfo
            let agreementVC = AgreementViewController(viewModel: agreementViewModel)
            agreementViewModel.coordinator = self
            navigationController.pushViewController(agreementVC, animated: false)
        case .findWelfare:
            childCoordinators = []
            mainCoordinator?.setAction(.registComplete)
        }
    }
}

extension AuthCoordinator {
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
