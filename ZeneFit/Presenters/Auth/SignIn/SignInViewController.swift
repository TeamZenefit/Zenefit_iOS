//
//  SignInViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/09/28.
//

import UIKit

final class SignInViewController: BaseViewController {
    weak var coordinator: Coordinator?
    
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "Logo")?.withRenderingMode(.alwaysOriginal)
    }
    
    private let dividerLeadingView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let dividertrailingView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let oauthGuideLabel = UILabel().then {
        $0.text = "SNS 계정으로 간단하게 가입하기"
        $0.textColor = .white
        $0.font = .pretendard(.body2)
    }
    
    private let kakaoLoginButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "Kakao")?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.layer.cornerRadius = 26
        $0.backgroundColor = .init(red: 1, green: 230/255, blue: 0, alpha: 1)
    }
    
    private let appleLoginButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "Apple")?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.layer.cornerRadius = 26
        $0.backgroundColor = .black
    }
    
    private lazy var oauthStackView = UIStackView(arrangedSubviews: [kakaoLoginButton, appleLoginButton]).then {
        $0.distribution = .fillEqually
        $0.spacing = 16
    }
    
    override func configureUI() {
        view.setGradient()
    }
    
    override func addSubView() {
        [logoImageView, dividerLeadingView, dividertrailingView, oauthGuideLabel, oauthStackView].forEach {
            view.addSubview($0)
        }
    }
    
    override func layout() {
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(125)
            $0.centerX.equalToSuperview()
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.height.width.equalTo(52)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.height.width.equalTo(52)
        }
        
        oauthStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(93)
            $0.centerX.equalToSuperview()
        }
        
        oauthGuideLabel.snp.makeConstraints {
            $0.bottom.equalTo(oauthStackView.snp.top).offset(-16)
            $0.centerX.equalToSuperview()
        }
        
        dividerLeadingView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(32)
            $0.trailing.equalTo(oauthGuideLabel.snp.leading).offset(-8)
            $0.height.equalTo(1)
            $0.centerY.equalTo(oauthGuideLabel)
        }
        
        dividertrailingView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(32)
            $0.leading.equalTo(oauthGuideLabel.snp.trailing).offset(8)
            $0.height.equalTo(1)
            $0.centerY.equalTo(oauthGuideLabel)
        }
    }
}
