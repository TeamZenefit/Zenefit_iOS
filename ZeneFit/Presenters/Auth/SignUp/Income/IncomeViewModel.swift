//
//  IncomeViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/03.
//

import Foundation
import Combine

final class IncomeViewModel {
    private var cancellable = Set<AnyCancellable>()
    
    @Published var signUpInfo = SignUpInfo()
    @Published var focusInputNumber = 1
    @Published var completionEnable = false
    
    init() {
        bind()
    }
    
    private func bind() {
        $signUpInfo
            .map {
                guard let income = $0.income else { return false }
                
                return !income.isEmpty && income.count <= 10
            }
            .eraseToAnyPublisher()
            .assign(to: \.completionEnable, on: self)
            .store(in: &cancellable)
    }
    
    func cacluateFocus() {
        let income = signUpInfo.income ?? ""
        
        if income.isEmpty {
            focusInputNumber = 1
        } else {
            focusInputNumber = 2
        }
    }
}
