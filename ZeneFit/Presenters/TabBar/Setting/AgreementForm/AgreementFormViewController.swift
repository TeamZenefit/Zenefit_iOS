//
//  AgreementFormViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import UIKit

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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        setTitle = "약관 및 개인정보 처리 동의"
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
