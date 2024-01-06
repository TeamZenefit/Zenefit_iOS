//
//  SettingRepositoryProtocol.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/10/23.
//

import Foundation
import Combine

protocol SettingRepositoryProtocol {
    func getSocialInfo() -> AnyPublisher<SocialInfoDTO, Error>
    func getUserInfo() -> AnyPublisher<UserInfoDTO, Error>
    func unregistUser() async throws
    func updateNotificationStatus(isAllow: Bool) -> AnyPublisher<Void, Error>
    func getNotificationStatus() -> AnyPublisher<NotificationStatusDTO, Error>
}
