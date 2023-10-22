//
//  RecommendWelFareDTO.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import Foundation

class RecommendWelFareDTO: Decodable {
    let nickname: String
    let policyCnt: Int
    
    func toDomain() -> RecommendWelFareEntity {
        RecommendWelFareEntity(nickname: self.nickname,
                               policyCnt: self.policyCnt)
    }
}

