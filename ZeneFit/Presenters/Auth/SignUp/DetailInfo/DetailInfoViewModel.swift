//
//  DetailInfoViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/03.
//

import Foundation
import Combine

final class DetailInfoViewModel {
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
                guard let education = $0.education,
                      let job = $0.job
                else { return false }
                
                return !education.isEmpty && !job.isEmpty
            }
            .eraseToAnyPublisher()
            .assign(to: \.completionEnable, on: self)
            .store(in: &cancellable)
    }
    
    func cacluateFocus() {
        let education = signUpInfo.education ?? ""
        let job = signUpInfo.job ?? []
        
        if education.isEmpty {
            focusInputNumber = 1
        } else if job.isEmpty {
            focusInputNumber = 2
        } else {
            focusInputNumber = 3
        }
    }
}
