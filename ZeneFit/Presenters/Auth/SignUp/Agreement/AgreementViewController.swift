//
//  AgreementViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/04.
//

import UIKit
import Combine

final class AgreementViewController: BaseViewController {
    private var cancellable = Set<AnyCancellable>()
    private let viewModel: AgreementViewModel
    
    private let basicInfoLabel = SignUpOrderLabel(number: 4, title: "약관 동의")
    
    private let titleLabel = UILabel().then {
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
    
    private let useAgreementView = AgreementView("이용 약관", isRequired: true)
    
    private let privacyAgreementView = AgreementView("개인정보 처리방침", isRequired: true)
    
    private let marketingAgreementView = AgreementView("마케팅 정보 수신 동의", isRequired: false)

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
            .sink { [weak self] error in
                switch error {
                case CommonError.serverError:
                    self?.notiAlert("서버 에러가 발생했습니다.\n잠시후 다시 시도해주세요.")
                default:
                    self?.notiAlert("알 수 없는 에러가 발생했습니다.\n잠시후 다시 시도해주세요.")
                }
            }.store(in: &cancellable)
    }
    
    override func addSubView() {
        [basicInfoLabel, titleLabel, completeButton, totalAgreementView, useAgreementView, privacyAgreementView, marketingAgreementView, dividerView].forEach {
            view.addSubview($0)
        }
    }
    
    override func layout() {
        basicInfoLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(basicInfoLabel.snp.bottom).offset(16)
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
