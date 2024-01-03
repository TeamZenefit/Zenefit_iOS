//
//  RemoveApplyingPolicyUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/1/24.
//

import Foundation

struct RemoveApplyingPolicyUseCase {
    private let policyRepo: PolicyRepositoryProtocol
    
    init(policyRepo: PolicyRepositoryProtocol = PolicyRepository()) {
        self.policyRepo = policyRepo
    }
    
    @discardableResult
    func execute(policyId: Int) async throws -> Bool {
        try await policyRepo.removeApplyingPolicy(policyId: policyId)
    }
}
