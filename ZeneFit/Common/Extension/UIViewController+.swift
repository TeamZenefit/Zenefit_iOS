//
//  UIViewController+.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/09/28.
//

import UIKit

extension UIViewController {
    func changeRootViewController(_ rootViewController: UIViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = rootViewController
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        } else {
            rootViewController.modalPresentationStyle = .overFullScreen
            self.present(rootViewController, animated: true, completion: nil)
        }
    }
}
