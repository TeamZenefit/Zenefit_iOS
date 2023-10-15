//
//  AgreementViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/04.
//

import Foundation
import Combine

final class AgreementViewModel {
    private var cancellable = Set<AnyCancellable>()
    
    @Published var signUpInfo = SignUpInfo()
    @Published var completionEnable = false
    
    @Published var totalAgree = false
    @Published var useAgree = false
    @Published var privacyAgree = false
    @Published var marketingAgree = false
    
    init() {
        bind()
    }
    
    private func bind() {
        $useAgree.combineLatest($privacyAgree, $marketingAgree)
            .map { $0.0 && $0.1 && $0.2 }
            .assign(to: \.totalAgree, on: self)
            .store(in: &cancellable)
        
        $useAgree.combineLatest($privacyAgree)
            .map { $0.0 && $0.1 }
            .assign(to: \.completionEnable, on: self)
            .store(in: &cancellable)
        
        $marketingAgree
            .assign(to: \.signUpInfo.marketingAgree, on: self)
            .store(in: &cancellable)
    }
}
