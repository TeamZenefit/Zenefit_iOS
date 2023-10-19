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
    
    init(signInUseCase: SignInUseCase = .init()) {
        self.signInUseCase = signInUseCase
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
                self?.loginResult.send(true)
            }).store(in: &cancellable)
            

    }
}
