//
//  SettingCoordinator.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/29.
//

import UIKit

final class SettingCoordinator: Coordinator {
    enum CoordinatorAction {
        case main,
             appInfo,
             agreementForm,
             loginInfo,
             personalInfo,
             personalInfoEdit(userInfo: UserInfoDTO),
             notiSetting,
             notiList
    }
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    weak var delegate: CoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        setAction(.main)
    }
    
    func setAction(_ action: CoordinatorAction) {
        switch action {
        case .main:
            let settingVM = SettingViewModel(coordinator: self)
            let settingVC = SettingViewController(viewModel: settingVM)
            navigationController.viewControllers = [settingVC]
        case .appInfo:
            let appInfoVM = AppInfoViewModel(coordinator: self)
            let appInfoVC = AppInfoViewController(viewModel: appInfoVM)
            navigationController.pushViewController(appInfoVC, animated: true)
        case .agreementForm:
            let agreementFormVM = AgreementFormViewModel(coordinator: self)
            let agreementFormVC = AgreementFormViewController(viewModel: agreementFormVM)
            navigationController.pushViewController(agreementFormVC, animated: true)
        case .loginInfo:
            let loginInfoVM = LoginInfoViewModel(coordinator: self)
            let loginInfoVC = LoginInfoViewController(viewModel: loginInfoVM)
            navigationController.pushViewController(loginInfoVC, animated: true)
        case .personalInfo:
            let personalInfoVM = PersonalInfoViewModel(cooridnator: self)
            let personalInfoVC = PersonalInfoViewController(viewModel: personalInfoVM)
            navigationController.pushViewController(personalInfoVC, animated: true)
        case .personalInfoEdit(let userInfo):
            let personalInfoEditVM = PersonalInfoEditViewModel(cooridnator: self,
                                                               currentUserInfo: userInfo)
            let personalInfoEditVC = PersonalInfoEditViewController(viewModel: personalInfoEditVM)
            navigationController.pushViewController(personalInfoEditVC, animated: true)
        case .notiSetting:
            let notiCoordinator = NotificationCoordinator(navigationController: navigationController)
            childCoordinators.append(notiCoordinator)
            notiCoordinator.delegate = self
            notiCoordinator.setAction(.notiSetting)
        case .notiList:
            let notiCoordinator = NotificationCoordinator(navigationController: navigationController)
            childCoordinators.append(notiCoordinator)
            notiCoordinator.delegate = self
            notiCoordinator.setAction(.notiList)
        }
    }
}
extension SettingCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: any Coordinator) {
        if childCoordinator is NotificationCoordinator {
            if !navigationController.viewControllers.contains(where: {
                ($0 is NotiViewController || $0 is NotiSettingViewController)
            }) {
                childCoordinators.removeAll(where: { $0 is NotificationCoordinator })
            }
        }
    }
}

extension SettingCoordinator {
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

