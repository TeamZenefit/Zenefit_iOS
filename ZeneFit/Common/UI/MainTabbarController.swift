//
//  MainTabbarController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import UIKit

final class MainTabbarController: UITabBarController {
    weak var coordinator: MainCoordinator?
    
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
        viewControllers?.forEach {
            $0.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.secondaryNormal], for: .selected)
            $0.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.textDisable], for: .normal)
        }
    }
}
