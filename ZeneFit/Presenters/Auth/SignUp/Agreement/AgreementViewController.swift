//
//  AgreementViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/04.
//

import UIKit
import Combine

final class AgreementViewController: BaseViewController {
    private let viewModel: AgreementViewModel
    
    private let titleLabel = BaseLabel().then {
        $0.font = .pretendard(.label1)
        $0.textColor = .textStrong
        $0.text = "회원님의 약관동의가 필요해요"
    }
    
    private let completeButton = BottomButton().then {
        $0.setTitle("확인", for: .normal)
        $0.layer.cornerRadius = 8
    }
    
    private let totalAgreementView = AgreementView("약관 전체동의", isRequired: true, isHighlight: true).then {
        $0.disclouserIsHidden = true
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .lineNormal
    }
    
    private lazy var useAgreementView = AgreementView("이용 약관", isRequired: true) { [weak self] in
        self?.openSafari(urlString: "https://www.notion.so/zenefit/25528979c42847e2b6738ab7fd4edd33?pvs=4")
    }
    
    private lazy var privacyAgreementView = AgreementView("개인정보 처리방침", isRequired: true) { [weak self] in
        self?.openSafari(urlString: "https://zenefit.notion.site/db4b51829a9e4be89c8ecbf6450215ac?pvs=4")
    }
    
    private lazy var marketingAgreementView = AgreementView("마케팅 정보 수신 동의", isRequired: false) { [weak self] in
        self?.openSafari(urlString: "https://zenefit.notion.site/1fc76d68d52d43558858627b16f50c08?pvs=4")
    }

    init(viewModel: AgreementViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupBinding() {
        useAgreementView.checkButton.tapPublisher.sink { [weak self] _ in
            guard let self else { return }
            viewModel.useAgree.toggle()
        }
        .store(in: &cancellable)
        
        privacyAgreementView.checkButton.tapPublisher.sink { [weak self] _ in
            self?.viewModel.privacyAgree.toggle()
        }
        .store(in: &cancellable)
        
        marketingAgreementView.checkButton.tapPublisher.sink { [weak self] _ in
            self?.viewModel.marketingAgree.toggle()
        }
        .store(in: &cancellable)
        
        totalAgreementView.checkButton.tapPublisher.sink { [weak self] _ in
            guard let self else { return }
            let allCheck = !viewModel.totalAgree
            viewModel.useAgree = allCheck
            viewModel.privacyAgree = allCheck
            viewModel.marketingAgree = allCheck
        }
        .store(in: &cancellable)
        
        viewModel.$useAgree
            .assign(to: \.useAgreementView.isAgree, on: self)
            .store(in: &cancellable)
        
        viewModel.$privacyAgree
            .assign(to: \.privacyAgreementView.isAgree, on: self)
            .store(in: &cancellable)
        
        viewModel.$marketingAgree
            .assign(to: \.marketingAgreementView.isAgree, on: self)
            .store(in: &cancellable)
        
        viewModel.$totalAgree
            .assign(to: \.totalAgreementView.isAgree, on: self)
            .store(in: &cancellable)
        
        viewModel.$completionEnable
            .assign(to: \.completeButton.isEnabled, on: self)
            .store(in: &cancellable)
        
        completeButton.tapPublisher
            .sink { [weak self] _ in
                self?.view.endEditing(false)
                self?.viewModel.didTapCompletion()
            }.store(in: &cancellable)
        
        viewModel.error
            .sink { error in
                switch error {
                case CommonError.serverError:
                    ToastView.showToast("서버 에러가 발생했습니다.\n잠시후 다시 시도해주세요.")
                default:
                    ToastView.showToast("알 수 없는 에러가 발생했습니다.\n잠시후 다시 시도해주세요.")
                }
            }.store(in: &cancellable)
    }
    
    override func addSubView() {
        [titleLabel, completeButton, totalAgreementView, useAgreementView, privacyAgreementView, marketingAgreementView, dividerView].forEach {
            view.addSubview($0)
        }
    }
    
    override func layout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        totalAgreementView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
        }
        
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(1)
            $0.top.equalTo(totalAgreementView.snp.bottom).offset(8)
        }
        
        useAgreementView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(dividerView.snp.bottom).offset(8)
        }
        
        privacyAgreementView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(useAgreementView.snp.bottom)
        }
        
        marketingAgreementView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(privacyAgreementView.snp.bottom)
        }
        
        completeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(52)
        }
    }
}
