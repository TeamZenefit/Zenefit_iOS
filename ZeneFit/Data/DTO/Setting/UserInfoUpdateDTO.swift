//
//  UserInfoUpdateDTO.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/21/24.
//

import Foundation

struct UserInfoUpdateDTO: Codable {
    let userID: Int
    let email, nickname: String
    let age: Int
    let address: Address
    let lastYearIncome: Int
    let educationType: String
    let jobs: [String]
    let policyCnt: Int
    let userDetail: UserDetail
    let fcmToken: String
    let pushNotificationStatus, appNotificationStatus: Bool
    let provider: String
    let benefit: Int
    let termsOfServiceStatus, privacyStatus, marketingStatus: Bool
    let marketingStatusDate: String?
    let manualStatus, userRegistrationValid: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case email, nickname, age, address, lastYearIncome, educationType, jobs, policyCnt, userDetail, fcmToken, pushNotificationStatus, appNotificationStatus, provider, benefit, termsOfServiceStatus, privacyStatus, marketingStatus, marketingStatusDate, manualStatus, userRegistrationValid
    }
}

// MARK: - Address
struct Address: Codable {
    let areaCode, cityCode: String
}

// MARK: - UserDetail
struct UserDetail: Codable {
    let id: Int
    let gender: String
    let smallBusiness, soldier, lowIncome, disabled: Bool
    let localTalent, farmer: Bool
}
