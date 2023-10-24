//
//  PolicyRepository.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import Foundation
import Combine

protocol PolicyRepositoryProtocol {
    func getRecommendWelfareList() -> AnyPublisher<RecommendWelFareEntity, Error>
}

class PolicyRepository: PolicyRepositoryProtocol {
    private let policyService: PolicyService
    
    init(policyService: PolicyService = .init()) {
        self.policyService = policyService
    }
    
    func getRecommendWelfareList() -> AnyPublisher<RecommendWelFareEntity, Error> {
        policyService.getRecommendWelfareList()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
