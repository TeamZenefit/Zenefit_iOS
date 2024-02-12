//
//  UIFont+.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/09/26.
//

import UIKit.UIFont

extension UIFont {
    public enum PretendardType: String {
        case bold = "Bold"
        case semibold = "SemiBold"
        case regular = "Regular"
    }

    static func pretendard(_ type: PretendardType, size: CGFloat) -> UIFont {
        
        return UIFont(name: "Pretendard-\(type.rawValue)", size: size)!
    }
    
    static func pretendard(_ type: FontSystemType) -> UIFont {
        
        return type.font
    }
}

public enum FontSystemType {
    case headline
    case title1
    case title2
    case label1
    case label2
    case label3
    case label4
    case label5
    case body1
    case body2
    case chips
    case caption
    
    public var lineHeight: CGFloat {
        switch self {
        case .headline: return 48
        case .title1: return 32
        case .title2, .label1: return 28
        case .label2: return 26
        case .label3, .body1: return 24
        case .label4, .body2: return 20
        case .label5, .chips: return 18
        case .caption: return 14
        }
    }
    
    public  var font: UIFont {
        switch self {
        case .headline:
            return .pretendard(.bold, size: 32)
        case .title1:
            return .pretendard(.bold, size: 24)
        case .title2:
            return .pretendard(.bold, size: 20)
        case .label1:
            return .pretendard(.semibold, size: 20)
        case .label2:
            return .pretendard(.semibold, size: 18)
        case .label3:
            return .pretendard(.semibold, size: 16)
        case .label4:
            return .pretendard(.semibold, size: 14)
        case .label5:
            return .pretendard(.semibold, size: 12)
        case .body1:
            return .pretendard(.regular, size: 16)
        case .body2:
            return .pretendard(.regular, size: 14)
        case .chips:
            return .pretendard(.regular, size: 12)
        case .caption:
            return .pretendard(.regular, size: 10)
        }
    }
}
