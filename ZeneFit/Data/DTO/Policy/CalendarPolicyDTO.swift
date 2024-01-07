//
//  CalendarPolicyDTO.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/6/24.
//

import Foundation

struct CalendarPolicyDTO: Codable {
    let policyId: Int
    let policyName: String
    let applyStatus: Bool
    let policyAgencyLogo: String?
    let applySttDate: String
    let applyEndDate: String
    let applyProcedure: String
}
