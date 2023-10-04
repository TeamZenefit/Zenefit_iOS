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
    
    var basicInfoViewModel = BasicInfoViewModel()
    var incomeViewModel = IncomeViewModel()
    var detailInfoViewModel = DetailInfoViewModel()
    var agreementViewModel = AgreementViewModel()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SignInViewModel()
        let signInVC = SignInViewController(viewModel: viewModel)
        signInVC.coordinator = self
        
        basicInfoViewModel = BasicInfoViewModel()
        let tempVC = BasicInfoInputViewController(viewModel: basicInfoViewModel)
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
        incomeViewModel = IncomeViewModel()
        incomeViewModel.signUpInfo = basicInfoViewModel.signUpInfo
        
        let incomeInputVC = IncomeInputViewController(viewModel: incomeViewModel)
        incomeInputVC.coordinator = self
        navigationController.pushViewController(incomeInputVC, animated: false)
    }
    
    func pushToDetailInfoInputVC() {
        detailInfoViewModel = DetailInfoViewModel()
        detailInfoViewModel.signUpInfo = incomeViewModel.signUpInfo
        let detailInputVC = DetailInfoInputViewController(viewModel: detailInfoViewModel)
        detailInputVC.coordinator = self
        navigationController.pushViewController(detailInputVC, animated: false)
    }
    
    func showAgreementVC() {
        agreementViewModel = AgreementViewModel()
        agreementViewModel.signUpInfo = detailInfoViewModel.signUpInfo
        let agreementVC = AgreementViewController(viewModel: agreementViewModel)
        agreementVC.coordinator = self
        navigationController.pushViewController(agreementVC, animated: false)
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
