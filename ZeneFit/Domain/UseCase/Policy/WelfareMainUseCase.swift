//
//  WelfareMainUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/20/23.
//

import Foundation
import Combine

class WelfareMainUseCase {
    private let policyRepo: PolicyRepositoryProtocol
    
    init(policyRepo: PolicyRepositoryProtocol = PolicyRepository()) {
        self.policyRepo = policyRepo
    }
    
    func getWelfareMainInfo() -> AnyPublisher<WelfareMainInfoDTO, Error> {
        policyRepo.getWelfareMainInfo()
    }
}
