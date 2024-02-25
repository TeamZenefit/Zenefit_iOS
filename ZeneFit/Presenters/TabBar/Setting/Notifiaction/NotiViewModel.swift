//
//  NotiViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import Foundation
import Combine

final class NotiViewModel {
    weak var coordinator: NotificationCoordinator?
    private var cancellable = Set<AnyCancellable>()
    
    @Published var categories = NotiDateType.allCases
    
    var error = PassthroughSubject<Error, Never>()
    
    @Published var selectedDateType = NotiDateType.none
    
    var notificationList = CurrentValueSubject<[NotificationInfo], Never>([])
    
    // page
    private var currentPage = 0
    private var isPaging: Bool = false
    private var isLastPage: Bool = false
    
    // usecase
    private let getNotificationUseCase: GetNotificationUseCase
    
    init(coordinator: NotificationCoordinator? = nil,
         getNotificationUseCase: GetNotificationUseCase = .init()) {
        self.coordinator = coordinator
        self.getNotificationUseCase = getNotificationUseCase
        
        bind()
    }
    
    func bind() {
        $selectedDateType
            .sink { [weak self] type in
                guard let self else { return }
                getNotificationInfo()
            
            }.store(in: &cancellable)
    }
    
    func getNotificationInfo() {
        resetData()
        self.getNotificationUseCase.execute(page: currentPage, dateType: selectedDateType)
        .sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished: break
            case .failure(let error):
                self?.error.send(error)
            }
        }, receiveValue: { [weak self] res in
            self?.notificationList.send(res.content)
            self?.isLastPage = res.last
        }).store(in: &cancellable)
    }
    
    func resetData() {
        isPaging = false
        isLastPage = false
        currentPage = 0
    }
    
    func didScroll(offsetY: CGFloat, contentHeight: CGFloat, frameHeight: CGFloat) {
        if offsetY > 0 && offsetY > (contentHeight - frameHeight) {
            if self.isPaging == false && !isLastPage { self.paging() }
        }
    }
}

private extension NotiViewModel {
    func paging() {
        isPaging = true
        currentPage += 1
        
        getNotificationUseCase.execute(page: currentPage, dateType: selectedDateType)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.isPaging = false
                    self?.error.send(error)
                case .finished: break
                }
            }, receiveValue: { [weak self] res in
                self?.notificationList.value.append(contentsOf: res.content)
                self?.isLastPage = res.last
                self?.isPaging = false
            }).store(in: &cancellable)
    }
}
