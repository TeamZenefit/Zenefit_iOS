//
//  UpdateFCMTokenUseCase.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/3/24.
//

import Foundation

struct UpdateFCMTokenUseCase {
    private let authRepo: AuthRepositoryProtocol
    
    init(authRepo: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepo = authRepo
    }
    
    func execute() async throws {
        guard let fcmToken = UserDefaults.standard.string(forKey: ZFKeyType.fcmToken.rawValue) else {
            throw CommonError.otherError
        }
        try await authRepo.updateFCMToken(fcmToken: fcmToken)
    }
}
