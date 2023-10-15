//
//  UIView+.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/09/28.
//

import UIKit

extension UIView {
    func setGradient() {
        let gradientLayer = CAGradientLayer().then {
            $0.frame = bounds
            $0.colors = [UIColor.primaryNormal.cgColor,
                         UIColor.secondaryNormal.cgColor]
            $0.startPoint = CGPoint(x: 0, y: 0)
            $0.endPoint = CGPoint(x: 0, y: 1)
        }
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func publisher<G>(for gestureRecognizer: G) -> UIGestureRecognizer.Publisher<G> where G: UIGestureRecognizer {
        UIGestureRecognizer.Publisher(gestureRecognizer: gestureRecognizer, view: self)
    }
}

