//
//  BaseLabel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/20/24.
//

import UIKit

class BaseLabel: UILabel {
    override var text: String? {
        didSet {
            self.setLineHeight(self.font)
        }
    }
}
