//
//  WelfareDetailViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/12/23.
//

import Foundation
import Combine

final class WelfareDetailViewModel {
    private var cancellable = Set<AnyCancellable>()
    private let policyId: Int
    
    weak var coordinator: WelfareCoordinator?
    
    var detailInfo = CurrentValueSubject<PolicyDetailDTO?, Never>(nil)
    var error = PassthroughSubject<Error, Never>()
    
    private let policyDetailUseCase: PolicyDetailUseCase
    private let addInterestPolicyUseCase: AddInterestPolicyUseCase
    private let removeInterestPolicyUseCase: RemoveInterestPolicyUseCase
    
    init(coordinator: WelfareCoordinator? = nil,
         policyDetailUseCase: PolicyDetailUseCase = .init(),
         removeInterestPolicyUseCase: RemoveInterestPolicyUseCase = .init(),
         addInterestPolicyUseCase: AddInterestPolicyUseCase = .init(),
         policyId: Int) {
        self.policyDetailUseCase = policyDetailUseCase
        self.removeInterestPolicyUseCase = removeInterestPolicyUseCase
        self.addInterestPolicyUseCase = addInterestPolicyUseCase
        self.coordinator = coordinator
        self.policyId = policyId
        
        getPolicyDetailInfo()
    }
    
    func getPolicyDetailInfo() {
        policyDetailUseCase.getPolicyDetailInfo(policyId: policyId)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self?.error.send(error)
                }
            },receiveValue: { [weak self] res in
                self?.detailInfo.send(res)
            }).store(in: &cancellable)
    }
    
    @discardableResult
    func addInterestPolicy(policyId: Int) async throws -> Bool {
        
        let isSuccess = try await addInterestPolicyUseCase.execute(policyId: policyId)
        var newDetailInfo = detailInfo.value
        newDetailInfo?.interestFlag = true
        detailInfo.send(newDetailInfo)
        
        return isSuccess
    }
    
    @discardableResult
    func removeInterestPolicy(policyId: Int) async throws -> Bool {
        let isSuccess = try await removeInterestPolicyUseCase.execute(policyId: policyId)
        var newDetailInfo = detailInfo.value
        newDetailInfo?.interestFlag = false
        detailInfo.send(newDetailInfo)
        
        return isSuccess
    }
}
