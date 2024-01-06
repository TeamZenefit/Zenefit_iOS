//
//  GetNotificationUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/6/24.
//

import Foundation
import Combine

struct GetNotificationUseCase {
    private let authRepo: AuthRepositoryProtocol
    
    init(authRepo: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepo = authRepo
    }
    
    func execute(page: Int) -> AnyPublisher<NotificationDTO, Error> {
        authRepo.getNotification(page: page)
    }
}
