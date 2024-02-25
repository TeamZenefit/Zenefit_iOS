//
//  BenefitPolicyDTO.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/19/23.
//

import Foundation

struct BenefitPolicyListDTO: Codable {
    let content: [BenefitPolicy]
    let pageable: Pageable
    let last: Bool
    let totalPages, totalElements, size, number: Int
    let sort: Sort
    let first: Bool
    let numberOfElements: Int
    let empty: Bool
}

struct BenefitPolicy: Codable {
    let policyID: Int
    let policyName, policyIntroduction: String
    let policyLogo: String?
    let benefit: Int?
    let benefitPeriod: String?
    
    enum CodingKeys: String, CodingKey {
        case policyID = "policyId"
        case policyName, policyIntroduction, policyLogo, benefit, benefitPeriod
    }
}
