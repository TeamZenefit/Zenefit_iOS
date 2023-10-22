//
//  FetchAreaUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/17.
//

import Foundation
import Combine

class FetchAreaUseCase {
    let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }
    
    func execute() -> AnyPublisher<[String], Error> {
        return authRepository.fetchAreaInfo()
    }
}
