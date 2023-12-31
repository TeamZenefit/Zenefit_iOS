//
//  WelfareSortButton.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/09.
//

import UIKit
import Combine

final class WelfareSortButton: UIButton {
    private var cancellable = Set<AnyCancellable>()
    
    var title: String = "수혜정책" {
        didSet {
            self.configuration?.attributedTitle = .init(title,
                                                        attributes: .init([.font : UIFont.pretendard(.body2),
                                                                           .foregroundColor : UIColor.textNormal]))
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        
        var configure = UIButton.Configuration.filled()
        configure.baseBackgroundColor = .fillNormal
        configure.image = .init(named: "i-op-20")
        configure.imagePadding = 8
        configure.background.cornerRadius = 16
        configure.attributedTitle = .init(title,
                                          attributes: .init([.font : UIFont.pretendard(.body2),
                                                             .foregroundColor : UIColor.textNormal]))
        configure.imagePlacement = .trailing
        
        self.configuration = configure
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
