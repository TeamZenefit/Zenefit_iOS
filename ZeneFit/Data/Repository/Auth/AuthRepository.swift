//
//  AuthRepository.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/15.
//

import Foundation
import Combine

final class AuthRepository: AuthRepositoryProtocol {
    private let authService: AuthService
    
    init(authService: AuthService = .init()) {
        self.authService = authService
    }
    
    func signIn(oauthType: OAuthType,
                token: String,
                nickname: String?) -> AnyPublisher<SignInResponse, Error> {
        return authService.signIn(oauthType: oauthType, token: token, nickname: nickname)
    }
    
    func fetchAreaInfo() -> AnyPublisher<[String], Error> {
        return authService.fetchAreaInfo()
    }
    
    func fetchCityInfo(area: String) -> AnyPublisher<[String], Error> {
        return authService.fetchCityInfo(area: area)
    }
    
    func signUp(signUpInfo: SignUpInfo)-> AnyPublisher<SignUpResponse, Error> {
        return authService.signUp(signUpInfo: signUpInfo)
    }
}
