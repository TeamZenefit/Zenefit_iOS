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
    
    public func setLineHeight(_ lineHeight: CGFloat) {
        let text = self.text ?? ""
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        style.alignment = self.textAlignment
        style.lineBreakMode = self.lineBreakMode
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: (lineHeight - self.font.lineHeight) / 4,
            .font: self.font!,
            .foregroundColor : self.textColor!
        ]
        
        let attrString = NSAttributedString(string: text,
                                            attributes: attributes)
        self.attributedText = attrString
    }
    
    public func setLineHeight(_ font: FontSystemType) {
        let text = self.text ?? ""
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = font.lineHeight
        style.minimumLineHeight = font.lineHeight
        style.alignment = self.textAlignment
        style.lineBreakMode = self.lineBreakMode
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: (font.lineHeight - self.font.lineHeight) / 4,
            .font: self.font!,
            .foregroundColor : self.textColor!,
        ]
        
        let attrString = NSAttributedString(string: text,
                                            attributes: attributes)
        self.attributedText = attrString
    }
}
