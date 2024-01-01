//
//  WelfareViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/05.
//

import Foundation
import Combine

final class WelfareViewModel {
    private var cancellable = Set<AnyCancellable>()
    weak var coordinator: WelfareCoordinator?
    
    var policyItems = CurrentValueSubject<[PolicyMainInfo], Never>([])
    var error = PassthroughSubject<Error, Never>()
    
    private let welfareMainUseCase: WelfareMainUseCase
    private let addInterestPolicyUseCase: AddInterestPolicyUseCase
    private let removeInterestPolicyUseCase: RemoveInterestPolicyUseCase
    
    init(coordinator: WelfareCoordinator? = nil,
         welfareMainUseCase: WelfareMainUseCase = .init(),
         addInterestPolicyUseCase: AddInterestPolicyUseCase = .init(),
         removeInterestPolicyUseCase: RemoveInterestPolicyUseCase = .init()) {
        self.coordinator = coordinator
        self.addInterestPolicyUseCase = addInterestPolicyUseCase
        self.removeInterestPolicyUseCase = removeInterestPolicyUseCase
        self.welfareMainUseCase = welfareMainUseCase
    }
    
    func getWelfareMainInfo() {
        welfareMainUseCase.getWelfareMainInfo()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self?.error.send(error)
                }
            }, receiveValue: { [weak self] res in
                self?.policyItems.send(res.policyInfos)
            }).store(in: &cancellable)
    }
    
    @discardableResult
    func addInterrestPolicy(policyId: Int) async throws -> Bool {
        let isSuccess = try await addInterestPolicyUseCase.execute(policyId: policyId)
        policyItems.value.filter { $0.policyID == policyId }.first?.interestFlag = true
        
        return isSuccess
    }
    
    @discardableResult
    func removeInterrestPolicy(policyId: Int) async throws -> Bool {
        let isSuccess = try await removeInterestPolicyUseCase.execute(policyId: policyId)
        policyItems.value.filter { $0.policyID == policyId }.first?.interestFlag = false
        
        return isSuccess
    }
}
