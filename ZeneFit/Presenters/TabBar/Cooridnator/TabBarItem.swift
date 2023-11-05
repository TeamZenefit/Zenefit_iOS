//
//  TabBarItem.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/29.
//

import UIKit

enum TabBarItem: CaseIterable {
    case home, welfare, schedule, setting
    
    var item: UITabBarItem {
        switch self {
        case .home:
            return .init(title: "홈",
                         image: .init(named: "HomeOff")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: .init(named: "HomeOn")?.withRenderingMode(.alwaysOriginal))
        case .welfare:
            return .init(title: "정책",
                         image: .init(named: "WelfareOff")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: .init(named: "WelfareOn")?.withRenderingMode(.alwaysOriginal))
        case .schedule:
            return .init(title: "달력",
                         image: .init(named: "CalendarOff")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: .init(named: "CalendarOn")?.withRenderingMode(.alwaysOriginal))
        case .setting:
            return .init(title: "설정",
                         image: .init(named: "SettingOff")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: .init(named: "SettingOn")?.withRenderingMode(.alwaysOriginal))
        }
    }
}
