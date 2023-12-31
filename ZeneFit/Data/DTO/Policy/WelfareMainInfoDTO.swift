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

struct PolicyMainInfo: Codable {
    let supportType, supportTypeDescription: String
    let policyID: Int
    let policyName: String
    let policyLogo: String
    let interestFlag: Bool
    let policyAreaCode, policyCityCode, policyIntroduction: String
    let supportTypePolicyCnt, benefit: Int
    let policyDateType: String

    enum CodingKeys: String, CodingKey {
        case supportType, supportTypeDescription
        case policyID = "policyId"
        case policyName, policyLogo, policyAreaCode, policyCityCode, policyIntroduction, supportTypePolicyCnt, benefit, policyDateType, interestFlag
    }
}

