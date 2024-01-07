//
//  ScheduleViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/5/24.
//

import Foundation
import Combine

class ScheduleViewModel {
    weak var coordinator: ScheduleCoordinator?
    
    var policyList = CurrentValueSubject<[CalendarPolicyDTO], Never>([])
    var error = PassthroughSubject<Error, Never>()
    
    // usecase
    private let getPolicy: GetPolicyWithDateUseCase
    
    init(coordinator: ScheduleCoordinator? = nil,
         getPolicyWithDateUseCase: GetPolicyWithDateUseCase = .init()) {
        self.coordinator = coordinator
        self.getPolicy = getPolicyWithDateUseCase
    }
    
    func getPolicy(year: Int, month: Int) {
        Task {
            do {
                let policyInfo = try await getPolicy.execute(year: year, month: month)
                policyList.send(policyInfo)
            } catch {
                self.error.send(error)
            }     
        }
    }
}
