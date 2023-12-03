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
            break
        case .notiSetting:
            let notiSettingVM = NotiSettingViewModel(coordinator: self)
            let notiSettingVC = NotiSettingViewController(viewModel: notiSettingVM)
            navigationController.pushViewController(notiSettingVC, animated: true)
        case .notiList:
            break
        }
    }
}
