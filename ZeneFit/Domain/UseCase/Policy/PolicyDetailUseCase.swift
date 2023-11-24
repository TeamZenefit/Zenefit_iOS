//
//  PolicyDetailUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/20/23.
//

import Foundation
import Combine

final class PolicyDetailUseCase {
    private let policyRepo: PolicyRepositoryProtocol
    
    init(policyRepo: PolicyRepositoryProtocol = PolicyRepository()) {
        self.policyRepo = policyRepo
    }
    
    func getPolicyDetailInfo(policyId: Int) -> AnyPublisher<PolicyDetailDTO, Error> {
        policyRepo.getPolicyDetailInfo(policyId: policyId)
    }
}
