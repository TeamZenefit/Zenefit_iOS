//
//  FindWelfareViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import Foundation
import Combine

final class FindWelfareViewModel {
    private var cancellable = Set<AnyCancellable>()
    
    private let findWelfareUseCase: FindWelfareUseCase
    
    // output
    var findResult = CurrentValueSubject<RecommendWelFareEntity, Never>(.init(nickname: "사용자",
                                                                             policyCnt: -1))
    var error = PassthroughSubject<Error, Never>()
    
    init(findWelfareUseCase: FindWelfareUseCase = .init()) {
        self.findWelfareUseCase = findWelfareUseCase
    }
    
    func findWelfareList() {
        findWelfareUseCase.execute()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self?.error.send(error)
                }
            }, receiveValue: { [weak self] response in
                self?.findResult.send(response)
            }).store(in: &cancellable)
    }
}
