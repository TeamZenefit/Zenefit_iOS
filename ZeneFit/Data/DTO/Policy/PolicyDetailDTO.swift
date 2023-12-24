//
//  PolicyDetailDTO.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/20/23.
//

import Foundation

struct PolicyDetailDTO: Codable {
    let policyId: Int
    let policyName, policyApplyDenialReason, policyIntroduction, policyApplyDocument: String
    let policyApplyMethod, policyApplyDate, applicationSite: String
    let policyDateType: String
    let policyDateTypeDescription: String
    let referenceSite: String
    let benefit: Int?
    let policyMethodType : String
    let policyMethodTypeDescription: String
}
