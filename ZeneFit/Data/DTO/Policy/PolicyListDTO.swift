//
//  PolicyListDTO.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/20/23.
//

import Foundation

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
struct PolicyInfoDTO: Codable {
    let policyID: Int
    let policyName: String
    let policyApplyDenialReason: String?
    let areaCode, cityCode: String
    let policyLogo: String
    let policyIntroduction: String
    let applyStatus: String?
    let benefit: Int
    let applyFlag, interestFlag: Bool

    enum CodingKeys: String, CodingKey {
        case policyID = "policyId"
        case policyName, policyApplyDenialReason, areaCode, cityCode, policyLogo, policyIntroduction, applyStatus, benefit, applyFlag, interestFlag
    }
}
