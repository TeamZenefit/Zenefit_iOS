//
//  FindWelfareUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import Foundation
import Combine

class FindWelfareUseCase {
    private let policyRepository: PolicyRepositoryProtocol
    
    init(policyRepository: PolicyRepositoryProtocol = PolicyRepository()) {
        self.policyRepository = policyRepository
    }
    
    func execute() -> AnyPublisher<RecommendWelFareEntity, Error> {
        return policyRepository.getRecommendWelfareList()
    }
}
