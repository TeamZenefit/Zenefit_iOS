//
//  SignUpUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/19.
//

import Foundation
import Combine

class SignUpUseCase {
    let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }
    
    func execute(signUpInfo: SignUpInfo)-> AnyPublisher<SignUpResponse, Error> {
        return authRepository.signUp(signUpInfo: signUpInfo)
    }
}
