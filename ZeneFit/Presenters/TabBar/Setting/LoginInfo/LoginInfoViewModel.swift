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
    private let unregistUserUseCase: UnregistUserUseCase
    
    init(coordinator: SettingCoordinator?,
         getSocialInfoUseCase: GetSocialInfoUseCase = .init(),
         unregistUserUseCase: UnregistUserUseCase = .init()) {
        self.coordinator = coordinator
        self.getSocialInfoUseCase = getSocialInfoUseCase
        self.unregistUserUseCase = unregistUserUseCase
        
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
    
    func unregistUser() async -> Bool {
        do {
            try await unregistUserUseCase.execute()
            return true
        } catch {
            self.errorPublisher.send(error)
            return false
        }
    }
    
    func logout() {
        KeychainManager.delete(key: "accessToken")
        KeychainManager.delete(key: "refreshToken")
        coordinator?.finish()
    }
}
