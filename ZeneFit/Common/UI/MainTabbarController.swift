//
//  MainTabbarController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import UIKit

final class MainTabbarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.textDisable.cgColor
        tabBar.layer.cornerRadius = 8
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        setControllers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setControllers() {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = .init(title: "홈",
                                  image: .init(named: "HomeOff")?.withRenderingMode(.alwaysOriginal),
                                  selectedImage: .init(named: "HomeOn")?.withRenderingMode(.alwaysOriginal))
        
        let welfareVC = WelfareViewController()
        welfareVC.tabBarItem = .init(title: "정책",
                                     image: .init(named: "WelfareOff")?.withRenderingMode(.alwaysOriginal),
                                     selectedImage: .init(named: "WelfareOn")?.withRenderingMode(.alwaysOriginal))
        
        let scheduleVC = ScheduleViewController()
        scheduleVC.tabBarItem = .init(title: "일정",
                                      image: .init(named: "CalendarOff")?.withRenderingMode(.alwaysOriginal),
                                      selectedImage: .init(named: "CalendarOn")?.withRenderingMode(.alwaysOriginal))
        
        let settingVC = SettingViewController()
        settingVC.tabBarItem = .init(title: "설정",
                                     image: .init(named: "SettingOff")?.withRenderingMode(.alwaysOriginal),
                                     selectedImage: .init(named: "SettingOn")?.withRenderingMode(.alwaysOriginal))
        
        viewControllers = [homeVC, welfareVC, scheduleVC, settingVC]
        viewControllers?.forEach {
            $0.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.secondaryNormal], for: .selected)
            $0.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.textDisable], for: .normal)
        }
    }
}
