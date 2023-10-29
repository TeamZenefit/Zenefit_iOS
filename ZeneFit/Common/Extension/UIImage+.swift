//
//  UIImage+.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/29.
//

import UIKit.UIImage

extension UIImage {
    static func gradientImage(with bounds: CGRect,
                              colors: [CGColor]) -> UIImage? {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.0,
                                           y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0,
                                         y: 0.5)
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}
