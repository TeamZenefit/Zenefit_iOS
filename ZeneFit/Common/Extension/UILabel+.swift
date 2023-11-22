//
//  UILabel+.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/22/23.
//

import UIKit.UILabel

extension UILabel {
    /// 부분 색상 강조
    /// - Parameter Color : 강조할 색상
    /// - Parameter Font : 강조할 폰트
    /// - Parameter pointText : 강조할 텍스트
    public func setPointTextAttribute(_ pointText: String,
                                  color: UIColor,
                                  font: UIFont? = nil) {
        guard let content = self.text else { return }
        
        let attributedStr = NSMutableAttributedString(string: content)
        attributedStr.addAttributes([.font : font ?? self.font!,
                                     .foregroundColor : color],
                                    range: (content as NSString).range(of: pointText))
        
        self.attributedText = attributedStr
    }
}
