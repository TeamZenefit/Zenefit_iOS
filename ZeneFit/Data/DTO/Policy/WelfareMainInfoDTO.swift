//
//  WelfareMainInfoDTO.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/20/23.
//

import Foundation

struct WelfareMainInfoDTO: Codable {
    let policyInfos: [PolicyMainInfo]
}

class PolicyMainInfo: Codable {
    let supportType: String
    let supportTypeDescription: String
    let policyId: Int
    let policyName: String
    let policyLogo: String?
    let applyFlag: Bool
    var interestFlag: Bool
    let policyAreaCode, policyIntroduction: String
    let policyCityCode: String?
    let supportTypePolicyCnt, benefit: Int
    let policyDateType: String
    let policyMethodType: String
}

