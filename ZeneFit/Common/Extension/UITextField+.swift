//
//  UITextField+.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/02.
//

import UIKit.UITextField
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap{ $0.object as? UITextField }
            .map{ $0.text ?? "" }    //값이 없는 경우 빈 문자열 반환
            .eraseToAnyPublisher()
    }
}
