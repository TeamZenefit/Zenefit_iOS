//
//  LoginInfoViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import UIKit
import SwiftUI

final class LoginInfoViewController: BaseViewController {
    private let viewModel: LoginInfoViewModel
    
    private let loginInfoItemView = SettingItemView(title: "현재 로그인", content: "카카오 ID").then {
        $0.contentTextColor = .primaryNormal
        $0.isHiddenDisclosure = true
    }
    
    private let logoutItemView = SettingItemView(title: "로그아웃하기").then {
        $0.contentTextColor = .primaryNormal
        $0.isHiddenDisclosure = true
    }
    
    private let withdrawalItemView = SettingItemView(title: "탈퇴하기").then {
        $0.contentTextColor = .primaryNormal
        $0.isHiddenDisclosure = true
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .backgroundPrimary
    }
    
    init(viewModel: LoginInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        setTitle = "로그인 정보"
    }
    
    override func setupBinding() {
        logoutItemView.gesturePublisher(for: .tap)
            .sink { [weak self] _ in
                self?.showLogoutNotification()
            }.store(in: &cancellable)
        
        withdrawalItemView.gesturePublisher(for: .tap)
            .sink { [weak self] _ in
                self?.showWithdrawalNotification()
            }.store(in: &cancellable)
        
        viewModel.$socialInfo
            .sink { [weak self] info in
                self?.loginInfoItemView.setContent(content: info.email)
            }.store(in: &cancellable)
    }
    
    private func showWithdrawalNotification() {
        let alert = StandardAlertController(title: "정말로 탈퇴히시겠습니까?",
                                            message: "탈퇴하시게 되면 취소할 수 없습니다.")
        let withdrawal = StandardAlertAction(title: "탈퇴하기", style: .basic) { [weak self] _ in
            self?.showWithdrawalCompletionNotification()
        }
        let no = StandardAlertAction(title: "아니오", style: .cancel)
        alert.addAction(no, withdrawal)
        
        present(alert, animated: false)
    }
    
    private func showLogoutNotification() {
        let alert = StandardAlertController(title: "정말로 로그아웃 하시겠습니까?",
                                            message: "로그아웃을 하게되면\n로그인 페이지로 돌아가게 됩니다.")
        let withdrawal = StandardAlertAction(title: "로그아웃", style: .basic) { [weak self] _ in
            self?.viewModel.logout()
        }
        let no = StandardAlertAction(title: "아니오", style: .cancel)
        alert.addAction(no, withdrawal)
        
        present(alert, animated: false)
    }
    
    private func showWithdrawalCompletionNotification() {
        let alert = StandardAlertController(title: "회원탈퇴가 완료되었습니다.\n감사합니다",
                                            message: nil)
        let ok = StandardAlertAction(title: "확인", style: .gray) { [weak self] _ in
            self?.viewModel.coordinator?.finish()
        }
        alert.addAction(ok)
        present(alert, animated: false)
    }
    
    override func addSubView() {
        [loginInfoItemView, dividerView, logoutItemView, withdrawalItemView].forEach {
            view.addSubview($0)
        }
    }
    
    override func layout() {
        loginInfoItemView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.horizontalEdges.equalToSuperview()
        }
        
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(loginInfoItemView.snp.bottom)
            $0.height.equalTo(12)
        }
        
        logoutItemView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(dividerView.snp.bottom)
        }
        
        withdrawalItemView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(logoutItemView.snp.bottom)
        }
    }
}

#Preview(body: {
    UINavigationController(rootViewController: LoginInfoViewController(viewModel: LoginInfoViewModel(coordinator: nil))).preview
    
})
