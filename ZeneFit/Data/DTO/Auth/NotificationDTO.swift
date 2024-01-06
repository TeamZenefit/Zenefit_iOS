//
//  NotificationDTO.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/6/24.
//

import Foundation


// MARK: - Result
struct NotificationDTO: Codable {
    let content: [Content]
    let pageable: Pageable
    let totalPages, totalElements: Int
    let last: Bool
    let size, number: Int
    let sort: Sort
    let numberOfElements: Int
    let first, empty: Bool
}

// MARK: - Content
struct Content: Codable {
    let notificationID: Int
    let title, content: String
    let logo: String

    enum CodingKeys: String, CodingKey {
        case notificationID = "notificationId"
        case title, content, logo
    }
}
