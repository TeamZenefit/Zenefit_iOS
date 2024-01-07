//
//  GetPolicyWithDateUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/7/24.
//

import Foundation

struct GetPolicyWithDateUseCase {
    private let policyRepo: PolicyRepositoryProtocol
    
    init(policyRepo: PolicyRepositoryProtocol = PolicyRepository()) {
        self.policyRepo = policyRepo
    }
    
    func execute(year: Int, month: Int) async throws -> [CalendarPolicyDTO] {
        let year = String(format: "%04d", year)
        let month = String(format: "%02d", month)
        return try await policyRepo.getPolicyWithDate(year: year, month: month)
    }
}
