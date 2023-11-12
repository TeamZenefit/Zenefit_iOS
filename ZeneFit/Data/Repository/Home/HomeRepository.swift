//
//  HomeRepository.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/12/23.
//

import Foundation
import Combine

final class HomeRepository: HomeRepositoryProtocol {
    private let service: HomeService
    
    init(service: HomeService = .init()) {
        self.service = service
    }
    
    func fetchHomeInfo() -> AnyPublisher<HomeInfoDTO, Error> {
        service.fetchHomeInfo()
    }
}
