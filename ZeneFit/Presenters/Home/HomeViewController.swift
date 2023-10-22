//
//  HomeViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import UIKit

final class HomeViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print(KeychainManager.read("accessToken"))
    }
}
