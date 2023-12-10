//
//  LoginInfoViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import Foundation
import Combine

final class LoginInfoViewModel {
    private var cancellable = Set<AnyCancellable>()
    
    weak var coordinator: SettingCoordinator?
    
    @Published var socialInfo: SocialInfoDTO = .init(email: "eamil",
                                                     provider: "none")
    var errorPublisher = PassthroughSubject<Error, Never>()
    
    // usecase
    private let getSocialInfoUseCase: GetSocialInfoUseCase
    
    init(coordinator: SettingCoordinator?,
         getSocialInfoUseCase: GetSocialInfoUseCase = .init()) {
        self.coordinator = coordinator
        self.getSocialInfoUseCase = getSocialInfoUseCase
        
        bind()
    }
    
    private func bind() {
        getSocialInfoUseCase.execute()
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorPublisher.send(error)
                }
            }, receiveValue: { [weak self] socialInfo in
                self?.socialInfo = socialInfo
            }).store(in: &cancellable)
    }
    
    func logout() {
        KeychainManager.delete(key: "accessToken")
        KeychainManager.delete(key: "refreshToken")
        coordinator?.finish()
    }
}
