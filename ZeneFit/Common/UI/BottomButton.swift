//
//  File.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/01.
//

import UIKit

final class BottomButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = .primaryNormal
                self.setTitleColor(.white, for: .normal)
            } else {
                self.backgroundColor = .fillDisable
                self.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        self.titleLabel?.font = .pretendard(.label1)
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .primaryNormal
        self.setTitleColor(.white, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
