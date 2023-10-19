//
//  SignInUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/02.
//

import Combine

class SignInUseCase {
    let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }
    
    func execute(oauthType: OAuthType,
                 token: String,
                 nickname: String?) -> AnyPublisher<SignInResponse, Error> {
        return authRepository.signIn(oauthType: oauthType,
                                     token: token,
                                     nickname: nickname)
    }
}
