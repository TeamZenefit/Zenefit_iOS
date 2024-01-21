//
//  UserInfoDTO.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/10/23.
//

import Foundation

struct UserInfoDTO: Codable {
    var nickname: String
    var age: Int
    var area: String
    var city: String
    var lastYearIncome: Double
    var educationType: String
    var jobs: [String]
    var gender: String
    var smallBusiness: Bool
    var soldier: Bool
    var lowIncome: Bool
    var disabled: Bool
    var localTalent: Bool
    var farmer: Bool
    
    var toEncodable: UserInfoEncodable {
        .init(nickname: nickname,
              age: age,
              areaCode: area,
              cityCode: city,
              lastYearIncome: lastYearIncome,
              educationType: educationType,
              jobs: jobs,
              userDetail: .init(gender: gender,
                                smallBusiness: smallBusiness,
                                soldier: soldier,
                                lowIncome: lowIncome,
                                disabled: disabled,
                                localTalent: localTalent,
                                farmer: farmer))
    }
}

struct UserInfoEncodable: Codable {
    var nickname: String
    var age: Int
    var areaCode: String
    var cityCode: String
    var lastYearIncome: Double
    var educationType: String
    var jobs: [String]
    var userDetail: UserDetail
    
    struct UserDetail: Codable {
        var gender: String
        var smallBusiness: Bool
        var soldier: Bool
        var lowIncome: Bool
        var disabled: Bool
        var localTalent: Bool
        var farmer: Bool
    }
}
