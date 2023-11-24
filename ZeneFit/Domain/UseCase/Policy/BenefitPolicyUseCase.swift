//
//  BenefitPolicyUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/19/23.
//

import Foundation
import Combine

class BenefitPolicyUseCase {
    private let policyRepo: PolicyRepositoryProtocol
    
    init(policyRepo: PolicyRepositoryProtocol = PolicyRepository()) {
        self.policyRepo = policyRepo
    }
    
    func getBenefitPolicyList(page: Int) -> AnyPublisher<BenefitPolicyListDTO, Error> {
        policyRepo.getBenefitPolicyList(page: page)
    }
}
