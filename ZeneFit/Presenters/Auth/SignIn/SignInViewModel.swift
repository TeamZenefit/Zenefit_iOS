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
    
    // Output
    var loginResult = PassthroughSubject<Bool, Never>()
    var errorPublisher = PassthroughSubject<Error, Never>()
    
    func requestLogin(type: OAuthType, token: String) {
        // TODO: - Sever에 토큰 보내기
    }
}
