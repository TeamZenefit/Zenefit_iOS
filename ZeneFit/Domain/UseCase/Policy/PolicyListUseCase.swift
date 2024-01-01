//
//  PolicyListUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/20/23.
//

import Foundation
import Combine

final class PolicyListUseCase {
    private let policyRepo: PolicyRepositoryProtocol
    
    init(policyRepo: PolicyRepositoryProtocol = PolicyRepository()) {
        self.policyRepo = policyRepo
    }
    
    func getPolicyInfo(page: Int,
                       supportPolicyType: SupportPolicyType,
                       policyType: PolicyType,
                       sortType: WelfareSortType,
                       keyword: String) -> AnyPublisher<PolicyListDTO, Error> {
        self.policyRepo.getPolicyInfo(page: page,
                                      supportPolicyType: supportPolicyType,
                                      policyType: policyType,
                                      sortType: sortType,
                                      keyword: keyword)
    }
}
