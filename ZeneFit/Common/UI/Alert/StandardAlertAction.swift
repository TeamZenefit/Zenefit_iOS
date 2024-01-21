//
//  StandardAlertAction.swift
//  OnandOff
//
//  Created by 신상우 on 2023/02/18.
//

import UIKit

enum StandardAlertStyle {
    case cancel
    case basic
    case gray
    case blue
}

final class StandardAlertAction: UIButton {
    let handler: ((StandardAlertAction) -> Void)?
    
    init(title: String?, style: StandardAlertStyle, handler: ((StandardAlertAction) -> Void)? = nil)  {
        self.handler = handler
        super.init(frame: .zero)
        let configure = UIButton.Configuration.filled()
        
        self.configuration = configure
        switch style {
        case .cancel:
            configuration?.baseBackgroundColor = .white
            configuration?.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
            configuration?.baseForegroundColor = .textAlternative
            configuration?.background.strokeColor = .textAlternative
            configuration?.background.strokeWidth = 1
        case .basic:
            configuration?.baseBackgroundColor = .alert
            configuration?.baseForegroundColor = .white
        case .gray:
            configuration?.baseBackgroundColor = .fillNormal
            configuration?.baseForegroundColor = .textAlternative
        case .blue:
            configuration?.baseBackgroundColor = .primaryNormal
            configuration?.baseForegroundColor = .white
        }
        
        configuration?.background.cornerRadius = 20
        configuration?.attributedTitle = .init(title ?? "",
                                               attributes: .init([.font : UIFont.pretendard(.body1)]))
        self.layer.masksToBounds = true
        self.addTarget(self, action: #selector(didClickAction), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector
    @objc private func didClickAction() {
        NotificationCenter.default.post(name: .dismissStandardAlert, object: nil)
        guard let handler = handler else { return }
        handler(self)
    }
}
