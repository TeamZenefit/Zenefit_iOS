//
//  BaseResponse.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/15.
//

import Foundation

class BaseResponse<T: Decodable>: Decodable {
    let code: Int
    let isSuccess: Bool
    let message: String
    let result: T
}
