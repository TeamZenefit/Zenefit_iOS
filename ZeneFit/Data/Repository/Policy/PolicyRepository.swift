//
//  PolicyRepository.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import Foundation
import Combine

final class PolicyRepository: PolicyRepositoryProtocol {
    private let policyService: PolicyService
    
    init(policyService: PolicyService = .init()) {
        self.policyService = policyService
    }
    
    func getRecommendWelfareList() -> AnyPublisher<RecommendWelFareEntity, Error> {
        policyService.getRecommendWelfareList()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func getBookmarkPolicyList(page: Int) -> AnyPublisher<BookmarkPolicyListDTO, Error> {
        policyService.getBookmarkPolicyList(page: page)
    }
    
    func getBenefitPolicyList(page: Int) -> AnyPublisher<BenefitPolicyListDTO, Error> {
        policyService.getBenefitPolicyList(page: page)
    }
    
    func getWelfareMainInfo() -> AnyPublisher<WelfareMainInfoDTO, Error> {
        policyService.getWelfareMainInfo()
    }
    
    func getPolicyInfo(page: Int,
                       supportPolicyType: SupportPolicyType,
                       policyType: PolicyType,
                       sortType: WelfareSortType) -> AnyPublisher<PolicyListDTO, Error> {
        policyService.getPolicyInfo(page: page,
                                    supportPolicyType: supportPolicyType,
                                    policyType: policyType,
                                    sortType: sortType)
    }
    
    func getPolicyDetailInfo(policyId: Int) -> AnyPublisher<PolicyDetailDTO, Error> {
        policyService.getPolicyDetailInfo(policyId: policyId)
    }
}
