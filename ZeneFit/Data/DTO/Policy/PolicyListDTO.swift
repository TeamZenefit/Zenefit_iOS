//
//  PolicyListDTO.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/20/23.
//

import Foundation

struct PolictListPagingDTO: Codable {
    let policyListInfoResponseDto: PolicyListDTO
    let last: Bool
    let pageNumber: Int
}

struct PolicyListDTO: Codable {
    let content: [PolicyInfoDTO]
    let pageable: Pageable
    let size, number: Int
    let sort: Sort
    let first, last: Bool
    let numberOfElements: Int
    let empty: Bool
}

// MARK: - Content
class PolicyInfoDTO: Codable {
    let policyId: Int
    let policyName: String
    let policyApplyDenialReason: String?
    let policyDateType: String
    let policyDateTypeDescription: String
    let policyMethodType: String
    let areaCode: String
    let cityCode: String?
    let policyLogo: String?
    let policyIntroduction: String
    var applyStatus: Bool
    let benefit: Int?
    var applyFlag, interestFlag: Bool
    let policyUrl: String?
    let benefitPeriod: String?
}
