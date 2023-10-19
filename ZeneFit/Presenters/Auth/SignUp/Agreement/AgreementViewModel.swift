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
    weak var coordinator: AuthCoordinator?
    
    @Published var signUpInfo = SignUpInfo()
    @Published var completionEnable = false
    var signUpResult = PassthroughSubject<Bool,Never>()
    var error = PassthroughSubject<Error,Never>()
    
    @Published var totalAgree = false
    @Published var useAgree = false
    @Published var privacyAgree = false
    @Published var marketingAgree = false
    
    private let signUpUseCase: SignUpUseCase
    
    init(signUpUseCase: SignUpUseCase = .init()) {
        self.signUpUseCase = signUpUseCase
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
    
    func didTapCompletion() {
        signUpUseCase.execute(signUpInfo: signUpInfo)
            .sink { [weak self] finish in
                switch finish {
                case .finished:
                    break
                case .failure(let error):
                    self?.error.send(error)
                }
            } receiveValue: { [weak self] res in
                // TODO: 토큰 저장
                print("accessToken: \(res.accessToken)")
                print("refreshToken: \(res.refreshToken)")
                self?.coordinator?.showRegistCompleteVC(userName: res.nickname)
            }.store(in: &cancellable)

    }
}
