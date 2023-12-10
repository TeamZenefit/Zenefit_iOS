//
//  UITableViewCell+.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import UIKit.UITableViewCell

extension UITableViewCell {
    static var identifier: String {
        .init(describing: self)
    }
}
