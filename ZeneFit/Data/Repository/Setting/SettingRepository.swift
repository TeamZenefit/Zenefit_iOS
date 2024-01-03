//
//  SettingRepository.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/10/23.
//

import Foundation
import Combine

final class SettingRepository: SettingRepositoryProtocol {
    private let service: UserService
    
    init(service: UserService = .init()) {
        self.service = service
    }
    
    func getSocialInfo() -> AnyPublisher<SocialInfoDTO, Error> {
        service.getSocialInfo()
    }
    
    func getUserInfo() -> AnyPublisher<UserInfoDTO, Error> {
        service.getUserInfo()
    }
    
    func unregistUser() async throws {
        try await service.unregistUser()
    }
}
