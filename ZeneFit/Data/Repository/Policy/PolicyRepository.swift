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
                       sortType: WelfareSortType,
                       keyword: String) -> AnyPublisher<PolicyListDTO, Error> {
        policyService.getPolicyInfo(page: page,
                                    supportPolicyType: supportPolicyType,
                                    policyType: policyType,
                                    sortType: sortType,
                                    keyword: keyword)
    }
    
    func getPolicyDetailInfo(policyId: Int) -> AnyPublisher<PolicyDetailDTO, Error> {
        policyService.getPolicyDetailInfo(policyId: policyId)
    }
    
    func addInterestPolicy(policyId: Int) async throws -> Bool {
        try await policyService.addInterestPolicy(policyId: policyId)
    }
    
    func removeInterestPolicy(policyId: Int?) async throws -> Bool {
        try await policyService.removeInterestPolicy(policyId: policyId)
    }
    
    func addApplyingPolicy(policyId: Int) async throws -> Bool {
        try await policyService.addApplyingPolicy(policyId: policyId)
    }
    
    func removeApplyingPolicy(policyId: Int?) async throws -> Bool {
        try await policyService.removeApplyingPolicy(policyId: policyId)
    }
    
    func getPolicyWithDate(year: String, month: String) async throws -> [CalendarPolicyDTO] {
        try await policyService.getPolicyWithDate(year: year, month: month)
    }
}
