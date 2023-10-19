//
//  FetchCityUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/17.
//

import Foundation
import Combine

class FetchCityUseCase {
    let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }
    
    func execute(area: String) -> AnyPublisher<[String], Error> {
        return authRepository.fetchCityInfo(area: area)
    }
}
