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
    
    init(coordinator: WelfareCoordinator? = nil,
         welfareMainUseCase: WelfareMainUseCase = .init()) {
        self.coordinator = coordinator
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
}
