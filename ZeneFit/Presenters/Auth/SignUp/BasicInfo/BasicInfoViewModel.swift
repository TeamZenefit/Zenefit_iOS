//
//  BasicInfoViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/01.
//

import Foundation
import Combine

final class BasicInfoViewModel {
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
                guard let age = $0.age,
                      let city = $0.city,
                      let area = $0.area else { return false }
                
                return !age.isEmpty && !city.isEmpty && !area.isEmpty
            }
            .eraseToAnyPublisher()
            .assign(to: \.completionEnable, on: self)
            .store(in: &cancellable)
    }
    
    func cacluateFocus() {
        let age = signUpInfo.age ?? ""
        let area = signUpInfo.area ?? ""
        let city = signUpInfo.city ?? ""
        
        if age.isEmpty {
            focusInputNumber = 1
        } else if area.isEmpty {
            focusInputNumber = 2
        } else if city.isEmpty {
            focusInputNumber = 3
        } else {
            focusInputNumber = 4
        }
    }
}
