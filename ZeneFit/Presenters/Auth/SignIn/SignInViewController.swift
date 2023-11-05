//
//  SignInViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/09/28.
//

import UIKit
import AuthenticationServices
import KakaoSDKUser
import Combine

final class SignInViewController: BaseViewController {
    private let viewModel: SignInViewModel
    weak var coordinator: AuthCoordinator?
    
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
        $0.text = "SNS 계정으로 간단하게 시작하기"
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
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func signInWithKakao() {
        UserApi.shared.logout() { _ in }

        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { [weak self] token, error in
                guard let token else { return }
                self?.viewModel.requestLogin(type: .kakao, token: token.accessToken)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount{ [weak self] token, error in
                guard let token else { return }
                self?.viewModel.requestLogin(type: .kakao, token: token.accessToken)
            }
        }
    }
    
    private func signInWithApple() {
        let appleProvider = ASAuthorizationAppleIDProvider()
        let request = appleProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()      
    }
    
    override func setupBinding() {
        kakaoLoginButton.tapPublisher.sink { [weak self] in
            self?.signInWithKakao()
        }
        .store(in: &cancellable)
        
        appleLoginButton.tapPublisher.sink { [weak self] in
            self?.signInWithApple()
        }
        .store(in: &cancellable)
        
        viewModel.loginResult
            .receive(on: RunLoop.main)
            .sink { [weak self] isSuccess in
                guard isSuccess else { return }
                self?.coordinator?.finish()
            }
            .store(in: &cancellable)
        
        viewModel.errorPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                switch error {
                case let CommonError.tempUser(userId):
                    self?.coordinator?.showRegistVC(userId: userId)
                case CommonError.serverError:
                    self?.notiAlert("서버 에러가 발생했습니다.\n잠시후 다시 시도해주세요.")
                default:
                    self?.notiAlert("알 수 없는 에러가 발생했습니다.\n잠시후 다시 시도해주세요.")
                }
            }
            .store(in: &cancellable)
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

extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let token = credential.identityToken,
              let tokenString = String(data: token, encoding: .utf8)
        else { return }
        
        self.viewModel.requestLogin(type: .apple, token: tokenString)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // TODO: 에러 처리
//        viewModel?.errorPublisher.send()
    }
}
