//
//  HomeInfoDTO.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/12/23.
//

import Foundation

struct HomeInfoDTO: Codable {
    let nickname: String
    let characterImage: String
    let characterNickname: String
    let characterPercent: Int
    let description: String
    let interestPolicyCnt, applyPolicyCnt: Int
    let recommendPolicy, endDatePolicy: [PolicyDTO]
}

struct PolicyDTO: Codable {
    let policyID: Int
    let policyName: String
    let policyLogo: String?
    let supportPolicyType, supportPolicyTypeName: String
    let dueDate: Int
    
    enum CodingKeys: String, CodingKey {
        case policyID = "policyId"
        case policyName, policyLogo, supportPolicyType, supportPolicyTypeName, dueDate
    }
}
