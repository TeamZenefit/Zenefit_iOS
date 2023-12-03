//
//  NotiViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import Foundation
import Combine

final class NotiViewModel {
    weak var coordinator: SettingCoordinator?
    
    @Published var categories = NotiCategory.allCases
    
    var selectedCategory = NotiCategory.none
    
    var notificationList = CurrentValueSubject<[NotificationItem], Never>([])
    
    init(coordinator: SettingCoordinator? = nil) {
        self.coordinator = coordinator
        
        notificationList.send([.init(title: "[정책 이름] 더미1",
                                     content: "더미내용 채우기",
                                     iconUrl: nil),
                               .init(title: "[정책 이름] 더미2",
                                     content: "더미2 내용 채우기",
                                     iconUrl: nil)]
        )
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
