//
//  SplashViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/09/26.
//

import UIKit
import SnapKit
import Then

final class SplashViewController: BaseViewController {
    weak var coordinator: MainCoordinator?
    
    private let splashImageView = UIImageView().then {
        $0.image = UIImage(named: "LogoType")?.withRenderingMode(.alwaysOriginal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryNormal
     
        view.addSubview(splashImageView)
        
        splashImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let _ = KeychainManager.read("accessToken") {
            // TODO: 일단 이걸로 체크..
            coordinator?.setAction(.tabBar)
        } else {
            coordinator?.setAction(.auth)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

