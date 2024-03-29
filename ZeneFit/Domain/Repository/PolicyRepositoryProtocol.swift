//
//  PolicyRepositable.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/12/23.
//

import Foundation
import Combine

protocol PolicyRepositoryProtocol {
    func getRecommendWelfareList() -> AnyPublisher<RecommendWelFareEntity, Error>
    func getBookmarkPolicyList(page: Int) -> AnyPublisher<BookmarkPolicyListDTO, Error>
    func getBenefitPolicyList(page: Int) -> AnyPublisher<BenefitPolicyListDTO, Error>
    func getWelfareMainInfo() -> AnyPublisher<WelfareMainInfoDTO, Error>
    func getPolicyInfo(page: Int,
                       supportPolicyType: SupportPolicyType,
                       policyType: PolicyType,
                       sortType: WelfareSortType,
                       keyword: String) -> AnyPublisher<PolictListPagingDTO, Error>
    func getPolicyDetailInfo(policyId: Int) -> AnyPublisher<PolicyDetailDTO, Error>
    
    func addInterestPolicy(policyId: Int) async throws -> Bool
    func removeInterestPolicy(policyId: Int?) async throws -> Bool
    
    func addApplyingPolicy(policyId: Int) async throws -> Bool
    func removeApplyingPolicy(policyId: Int?) async throws -> Bool
    func getPolicyWithDate(year: String, month: String) async throws -> [CalendarPolicyDTO]
}
