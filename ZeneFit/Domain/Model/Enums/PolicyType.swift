//
//  PolicyType.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/20/23.
//

import Foundation

enum PolicyType: String, CaseIterable {
    case none = "NONE"
    case job = "JOB"
    case education = "EDUCATION"
    case residence = "RESIDENCE"
    case culture = "WELFARE_CULTURE"
    case partipication = "PARTICIPATION_RIGHT"
    
    var description: String {
        switch self {
        case .none:
            "전체"
        case .job:
            "취업"
        case .education:
            "창업"
        case .residence:
            "주거∙금융"
        case .culture:
            "생활∙복지"
        case .partipication:
            "사회 참여"
        }
    }
}
