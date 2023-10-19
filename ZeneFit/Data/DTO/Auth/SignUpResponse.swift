//
//  SignUpResponse.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/19.
//

import Foundation

struct SignUpResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let nickname: String
}
