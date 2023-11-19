//
//  BookmarkPolicyListDTO.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/19/23.
//

import Foundation


// MARK: - Result
struct BookmarkPolicyListDTO: Codable {
    let content: [BookmarkPolicy]
    let pageable: Pageable
    let last: Bool
    let totalPages, totalElements, size, number: Int
    let sort: Sort
    let first: Bool
    let numberOfElements: Int
    let empty: Bool
}

struct BookmarkPolicy: Codable {
    let policyID: Int
    let policyName, policyIntroduction: String
    let policyLogo: String
    let applyEndDate: String

    enum CodingKeys: String, CodingKey {
        case policyID = "policyId"
        case policyName, policyIntroduction, policyLogo, applyEndDate
    }
}

struct Pageable: Codable {
    let sort: Sort
    let offset, pageNumber, pageSize: Int
    let paged, unpaged: Bool
}

struct Sort: Codable {
    let empty, sorted, unsorted: Bool
}

