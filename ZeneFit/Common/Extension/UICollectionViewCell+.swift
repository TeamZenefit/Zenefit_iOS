//
//  UICollectionViewCell+.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import UIKit.UICollectionViewCell

extension UICollectionViewCell {
    static var identifier: String {
        .init(describing: self)
    }
}
