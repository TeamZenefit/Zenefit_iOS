//
//  NotiSettingViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import Foundation
import Combine

final class NotiSettingViewModel {
    weak var coordinator: NotificationCoordinator?
    private var cancellable = Set<AnyCancellable>()
    
    @Published var notificationState: Bool = false
    var error = PassthroughSubject<Error, Never>()
    
    // usecase
    private let getNotificationStateUseCase: GetNotificationStateUseCase
    private let updateNotificationStateUseCase: UpdateNotificationStateUseCase
    
    init(coordinator: NotificationCoordinator? = nil,
         getNotificationStateUseCase: GetNotificationStateUseCase = .init(),
         updateNotificationStateUseCase: UpdateNotificationStateUseCase = .init()
    ) {
        self.coordinator = coordinator
        self.getNotificationStateUseCase = getNotificationStateUseCase
        self.updateNotificationStateUseCase = updateNotificationStateUseCase
        
        bind()
    }
    
    func bind() {
        getNotificationStateUseCase.execute()
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.error.send(error)
                }
            }, receiveValue: { [weak self] state in
                self?.notificationState = state.alarmStatus
            }).store(in: &cancellable)
    }
    
    func updateNotificationState(isOn: Bool) {
        updateNotificationStateUseCase.execute(isAllow: isOn)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.error.send(error)
                }
            }, receiveValue: { [weak self] _ in
                self?.notificationState.toggle()
            }).store(in: &cancellable)
            
    }
}
