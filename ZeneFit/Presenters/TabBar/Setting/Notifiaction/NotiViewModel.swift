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
    
    @Published var categories = NotiCategory.allCases
    
    var error = PassthroughSubject<Error, Never>()
    
    var selectedCategory = NotiCategory.none
    
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
        
        getNotificationInfo()
    }
    
    func getNotificationInfo() {
        isLastPage = false
        currentPage = 0
        self.getNotificationUseCase.execute(page: currentPage)
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
    
    
    func didScroll(offsetY: CGFloat, contentHeight: CGFloat, frameHeight: CGFloat) {
        if offsetY > 0 && offsetY > (contentHeight - frameHeight) {
            if self.isPaging == false && !isLastPage { self.paging() }
        }
    }
}

extension NotiViewModel {
    enum NotiCategory: String, CaseIterable {
        case none = "NONE"
        case startDay = "STARTDAY"
        case endDay = "ENDDAY"
        case activity = "ACTIVITY"
        
        var description: String {
            switch self {
            case .none:
                "전체"
            case .startDay:
                "시작일"
            case .endDay:
                "마감일"
            case .activity:
                "활동"
            }
        }
    }
}

private extension NotiViewModel {
    func paging() {
        isPaging = true
        currentPage += 1
        getNotificationUseCase.execute(page: currentPage)
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
