//
//  AgreementInfoDTO.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/7/24.
//

import Foundation

struct AgreementInfoDTO: Codable {
    let termsOfServiceDate: String
    let privacyDate: String
    let marketingDate: String?
    let termsOfServiceUrl: String
    let privacyUrl: String
    let marketingUrl: String
}
