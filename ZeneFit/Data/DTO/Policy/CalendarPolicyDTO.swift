//
//  CalendarPolicyDTO.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/6/24.
//

import Foundation

struct CalendarPolicyDTO: Codable {
    let policyID: Int
    let policyName: String
    let policyApplyStatus: Bool?
    let policyAgencyLogo: String?
    let policySttDateOrEndDate: String

    enum CodingKeys: String, CodingKey {
        case policyID = "policyId"
        case policyName, policyApplyStatus, policyAgencyLogo, policySttDateOrEndDate
    }
}
