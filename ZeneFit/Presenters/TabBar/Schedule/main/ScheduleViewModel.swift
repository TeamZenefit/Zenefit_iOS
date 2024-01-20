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
    private let deleteBookmark: RemoveInterestPolicyUseCase
    
    init(coordinator: ScheduleCoordinator? = nil,
         getPolicyWithDateUseCase: GetPolicyWithDateUseCase = .init(),
         deleteBookmark: RemoveInterestPolicyUseCase = .init()) {
        self.coordinator = coordinator
        self.getPolicy = getPolicyWithDateUseCase
        self.deleteBookmark = deleteBookmark
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
    
    func deleteBookmark(policyId: Int?) {
        Task {
            do {
                try await deleteBookmark.execute(policyId: policyId)
                policyList.value.removeAll(where: { $0.policyId == policyId })
            } catch {
                self.error.send(error)
            }
        }
    }
}
