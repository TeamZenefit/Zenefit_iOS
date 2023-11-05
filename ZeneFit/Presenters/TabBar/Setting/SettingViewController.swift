//
//  SettingViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import UIKit

final class SettingViewController: BaseViewController {
    private let tempLogoutButton = UIButton(type: .system).then {
        $0.setTitle("임시 로그아웃", for: .normal)
    }
    
    private let viewModel: SettingViewModel
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationItem.leftBarButtonItem = nil
    }
    
    override func addSubView() {
        view.addSubview(tempLogoutButton)
    }
    
    override func layout() {
        tempLogoutButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func setupBinding() {
        tempLogoutButton.tapPublisher
            .sink { [weak self] in
                self?.viewModel.logout()
            }.store(in: &cancellable)
    }
}
