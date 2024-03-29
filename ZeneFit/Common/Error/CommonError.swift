//
//  CommonError.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/02.
//

import Foundation

enum CommonError: Error {
    case invalidURL
    case otherError
    case serverError
    case tempUser(String)
    
    // policy
    case alreadyInterestingPolicy
    
    // user
    case unregist
    case invalidAge
    case invalidIncome
    case emptyCity
    case invalidJWT
}
