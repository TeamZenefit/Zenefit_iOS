//
//  BookmarkPolicyUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/19/23.
//

import Foundation
import Combine

class BookmarkPolicyUseCase {
    private let policyRepo: PolicyRepositoryProtocol
    
    init(policyRepo: PolicyRepositoryProtocol = PolicyRepository()) {
        self.policyRepo = policyRepo
    }
    
    func getBookmarkPolicyList(page: Int) -> AnyPublisher<BookmarkPolicyListDTO, Error> {
        return policyRepo.getBookmarkPolicyList(page: page)
    }
}
