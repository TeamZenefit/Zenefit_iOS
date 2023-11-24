//
//  PolicyDetailDTO.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/20/23.
//

import Foundation

struct PolicyDetailDTO: Codable {
    let policyID: Int
    let policyName, policyApplyDenialReason, policyIntroduction, policyApplyDocument: String
    let policyApplyMethod, policyApplyDate, applicationSite: String
    let referenceSite: String

    enum CodingKeys: String, CodingKey {
        case policyID = "policyId"
        case policyName, policyApplyDenialReason, policyIntroduction, policyApplyDocument, policyApplyMethod, policyApplyDate, applicationSite, referenceSite
    }
}
