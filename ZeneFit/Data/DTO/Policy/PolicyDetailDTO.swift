//
//  PolicyDetailDTO.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/20/23.
//

import Foundation

class PolicyDetailDTO: Codable {
    let policyId: Int
    let policyApplyDenialReason: String?
    let policyName, policyIntroduction, policyApplyDocument: String
    let policyApplyMethod, policyApplyDate, applicationSite: String
    let policyDateType: String
    let policyDateTypeDescription: String
    let referenceSite: String
    let benefit: Int?
    let policyMethodType : String
    let policyMethodTypeDescription: String
    var applyFlag: Bool
    var interestFlag: Bool
    let benefitPeriod: String?
}
