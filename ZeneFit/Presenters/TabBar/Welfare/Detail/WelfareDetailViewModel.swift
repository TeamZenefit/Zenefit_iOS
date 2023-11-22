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
    weak var coordinator: WelfareCoordinator?
    
    var detailInfo = CurrentValueSubject<PolicyDetailDTO?, Never>(nil)
    var error = PassthroughSubject<Error, Never>()
    
    private let policyDetailUseCase: PolicyDetailUseCase
    
    init(coordinator: WelfareCoordinator? = nil,
         policyDetailUseCase: PolicyDetailUseCase = .init(),
         policyId: Int) {
        self.policyDetailUseCase = policyDetailUseCase
        self.coordinator = coordinator
        
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
}
