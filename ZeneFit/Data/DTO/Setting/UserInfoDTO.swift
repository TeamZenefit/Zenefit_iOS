//
//  UserInfoDTO.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/10/23.
//

import Foundation

struct UserInfoDTO: Codable {
    let nickname: String
    let age: Int
    let area: String
    let city: String
    let lastYearIncome: Double
    let educationType: String
    let jobs: [String]
    let gender: String
    let smallBusiness: Bool
    let soldier: Bool
    let lowIncome: Bool
    let disabled: Bool
    let localTalent: Bool
    let farmer: Bool
}
