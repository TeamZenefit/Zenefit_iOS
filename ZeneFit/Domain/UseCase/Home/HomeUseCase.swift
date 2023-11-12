//
//  HomeUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/12/23.
//

import Foundation
import Combine

final class HomeUseCase {
    private let homeRepository: HomeRepositoryProtocol
    
    init(homeRepository: HomeRepositoryProtocol = HomeRepository()) {
        self.homeRepository = homeRepository
    }
    
    func fetchHomeInfo() -> AnyPublisher<HomeInfoDTO, Error> {
        homeRepository.fetchHomeInfo()
    }
}
