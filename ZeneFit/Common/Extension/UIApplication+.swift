//
//  UIApplication+.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2/12/24.
//

import UIKit.UIApplication

extension UIApplication {
    var scene: UIWindowScene? {
        UIApplication
            .shared
            .connectedScenes
            .first as? UIWindowScene
    }
    
    var window: UIWindow? {
        scene?
            .windows
            .first(where: { $0.isKeyWindow })
    }
    
    var root: UIViewController? {
        window?.rootViewController
    }
    
    var screenSize: CGRect? {
        root?.view.frame
    }
    
}
