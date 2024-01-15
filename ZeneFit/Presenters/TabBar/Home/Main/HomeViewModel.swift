//
//  HomeViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/29.
//

import Foundation
import Combine

final class HomeViewModel {
    weak var coordinator: HomeCoordinator?
    
    private var cancellable = Set<AnyCancellable>()
    private let usecase: HomeUseCase
   
    // output
    var info = CurrentValueSubject<HomeInfoDTO?, Never>.init(.none)
    var error = PassthroughSubject<Error, Never>()
    
    init(coordinator: HomeCoordinator? = nil,
         usecase: HomeUseCase = .init()) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    func fetchBenefitList() {
        
    }
    
    func fetchMainInfo() {
        usecase.fetchHomeInfo()
            .sink { [weak self] finish in
                switch finish {
                case .failure(let error):
                    self?.error.send(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] info in
                self?.info.send(info)
            }.store(in: &cancellable)
    }
}
