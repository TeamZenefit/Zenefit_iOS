//
//  UIViewController+.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/09/28.
//

import UIKit
import SwiftUI

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
    
    func notiAlert(_ content: String) {
        let alert = StandardNotificationAlertView(content)
        
        self.view.addSubview(alert)
        
        alert.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
    
    @available(iOS 13.0, *)
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> some UIViewController {
            viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    }
    
    public var preview: some View {
        return Preview(viewController: self)
    }
}

