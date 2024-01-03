//
//  SignInViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/09/29.
//

import UIKit
import Combine

final class SignInViewModel {
    private var cancellable = Set<AnyCancellable>()
    
    private let signInUseCase: SignInUseCase
    private let updateFCMTokenUseCase: UpdateFCMTokenUseCase
    
    init(signInUseCase: SignInUseCase = .init(),
         updateFCMTokenUseCase: UpdateFCMTokenUseCase = .init()) {
        self.signInUseCase = signInUseCase
        self.updateFCMTokenUseCase = updateFCMTokenUseCase
    }
    
    // Output
    var loginResult = PassthroughSubject<Bool, Never>()
    var errorPublisher = PassthroughSubject<Error, Never>()
    
    func requestLogin(type: OAuthType, token: String, nickname: String? = nil) {
        signInUseCase.execute(oauthType: type, token: token, nickname: nickname)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self?.errorPublisher.send(error)
                }
            }, receiveValue: { [weak self] result in
                guard let self,
                      let accessToken = result.accessToken,
                      let refreshToken = result.refreshToken else {
                    self?.loginResult.send(false)
                    return
                }
                KeychainManager.create(key: "accessToken", value: accessToken)
                KeychainManager.create(key: "refreshToken", value: refreshToken)
                Task {
                    try? await self.updateFCMTokenUseCase.execute()
                }
                
                self.loginResult.send(true)
            }).store(in: &cancellable)
            

    }
}
