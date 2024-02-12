//
//  AgreementFormViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import UIKit
import SafariServices

final class AgreementFormViewController: BaseViewController {
    private let viewModel: AgreementFormViewModel
    
    private let termOfServiceItemView = SettingItemView(title: "이용 약관",
                                                        content: "0000.00.00").then {
        $0.contentTextColor = .primaryNormal
        $0.contentTextFont = .pretendard(.body2)
    }
    
    private let privacyPolicyItemView = SettingItemView(title: "개인정보처리방침",
                                                        content: "0000.00.00").then {
        $0.contentTextColor = .primaryNormal
        $0.contentTextFont = .pretendard(.body2)
    }
    
    private let marketingInfoItemView = SettingItemView(title: "마케팅 정보 수신 동의",
                                                        content: "0000.00.00").then {
        $0.contentTextColor = .primaryNormal
        $0.contentTextFont = .pretendard(.body2)
    }
    
    init(viewModel: AgreementFormViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.getAgreement()
        
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        setTitle = "약관 및 개인정보 처리 동의"
    }
    
    override func setupBinding() {
        viewModel.$agreementInfo
            .receive(on: RunLoop.main)
            .sink { [weak self] info in
                guard let self else { return }
                termOfServiceItemView.setContent(content: info.termsOfServiceDate.hipenToDot)
                privacyPolicyItemView.setContent(content: info.privacyDate.hipenToDot)
                marketingInfoItemView.setContent(content: info.marketingDate?.hipenToDot ?? "미동의")
                
                termOfServiceItemView.gesturePublisher(for: .tap)
                    .receive(on: RunLoop.main)
                    .sink { [weak self] _ in
                        self?.openTermOfUseContentWithSafari(urlString: info.termsOfServiceUrl)
                    }.store(in: &cancellable)
                
                privacyPolicyItemView.gesturePublisher(for: .tap)
                    .receive(on: RunLoop.main)
                    .sink { [weak self] _ in
                        self?.openTermOfUseContentWithSafari(urlString: info.privacyUrl)
                    }.store(in: &cancellable)
                
                marketingInfoItemView.gesturePublisher(for: .tap)
                    .receive(on: RunLoop.main)
                    .sink { [weak self] _ in
                        self?.openTermOfUseContentWithSafari(urlString: info.marketingUrl)
                    }.store(in: &cancellable)
            }.store(in: &cancellable)
    }
    
    private func openTermOfUseContentWithSafari(urlString: String) {
        guard let termURL = URL(string: urlString) else { return }

        let safariViewController = SFSafariViewController(url: termURL)
        safariViewController.modalPresentationStyle = .automatic
        self.present(safariViewController, animated: true, completion: nil)
    }
    
    override func addSubView() {
        [termOfServiceItemView, privacyPolicyItemView, marketingInfoItemView].forEach {
            view.addSubview($0)
        }
    }
    
    override func layout() {
        termOfServiceItemView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.horizontalEdges.equalToSuperview()
        }
        
        privacyPolicyItemView.snp.makeConstraints {
            $0.top.equalTo(termOfServiceItemView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        marketingInfoItemView.snp.makeConstraints {
            $0.top.equalTo(privacyPolicyItemView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
