//
//  PaddingLabel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/09/28.
//

import UIKit

final class PaddingLabel: BaseLabel {
    var top: CGFloat = 0
    var bottom: CGFloat = 0
    var left: CGFloat = 0
    var right: CGFloat = 0
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.top = padding.top
        self.left = padding.left
        self.bottom = padding.bottom
        self.right = padding.right
    }
    
    /// - Parameter allPadding: 전체 패딩
    convenience init(allPadding: CGFloat) {
        self.init()
        self.top = allPadding
        self.left = allPadding
        self.bottom = allPadding
        self.right = allPadding
    }
    
    /// - Parameters:
    ///   - vPadding: 수직 패딩
    ///   - hPadding: 수평 패딩
    convenience init(vPadding: CGFloat, hPadding: CGFloat) {
        self.init()
        self.top = vPadding
        self.left = hPadding
        self.bottom = vPadding
        self.right = hPadding
    }
    
    override func drawText(in rect: CGRect) {
        let inset = UIEdgeInsets(top: self.top, left: self.left, bottom: self.bottom, right: self.right)
        super.drawText(in: rect.inset(by: inset))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + self.left + self.right,
                      height: size.height + self.top + self.bottom)
    }
}
