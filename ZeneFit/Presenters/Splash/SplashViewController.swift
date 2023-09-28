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
        
        // TODO: - 추후 자동 로그인 적용 필요
        coordinator?.pushToLoginVC()
    }
}

