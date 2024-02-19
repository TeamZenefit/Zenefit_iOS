//
//  JobType.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2/18/24.
//

import Foundation

enum JobType: String, CaseIterable {
    case employed = "재직자"
    case selfEmployed = "자영업자"
    case unemployed = "미취업자"
    case freelancer = "프리랜서"
    case dailyWorker = "일용근로자"
    case entrepreneur = "창업자"
    case shortTermWorker = "단기근로자"
    case farmer = "영농종사자"
    case unlimited = "제한없음"
    case etc = "기타"
    
    var title: String {
        switch self {
            
        case .employed:
            "재직자"
        case .selfEmployed:
            "자영업자"
        case .unemployed:
            "미취업자"
        case .freelancer:
            "프리랜서"
        case .dailyWorker:
            "일용근로자"
        case .entrepreneur:
            "창업자"
        case .shortTermWorker:
            "단기근로자"
        case .farmer:
            "영농종사자"
        case .unlimited:
            "제한없음"
        case .etc:
            "기타"
        }
    }
}
