//
//  SignInResponse.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/15.
//

import Foundation

class SignInResponse: Decodable {
    let accessToken: String?
    let refreshToken: String?
    let userId: String?
}
