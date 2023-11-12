//
//  AuthRepositoryProtocol.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/12/23.
//

import Foundation
import Combine

protocol AuthRepositoryProtocol {
    func fetchAreaInfo() -> AnyPublisher<[String], Error>
    func fetchCityInfo(area: String) -> AnyPublisher<[String], Error>
    func signIn(oauthType: OAuthType,
                token: String,
                nickname: String?) -> AnyPublisher<SignInResponse, Error>
    func signUp(signUpInfo: SignUpInfo)-> AnyPublisher<SignUpResponse, Error>
}
