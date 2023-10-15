//
//  RegistCompleteViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/15.
//

import UIKit

final class RegistCompleteViewController: BaseViewController {
    weak var coordinator: AuthCoordinator?
    
    private let subTitleLabel = UILabel().then {
        $0.text = "회원가입 완료!"
        $0.textColor = .textAlternative
        $0.font = .pretendard(.chips)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "회원가입을 환영합니다"
        $0.textColor = .textNormal
        $0.font = .pretendard(.label3)
    }
    
    private let userNameLabel = UILabel().then {
        $0.text = "닉네임님!"
        $0.textColor = .textNormal
        $0.font = .pretendard(.title2)
    }
    
    init(userName: String?) {
        self.userNameLabel.text = (userName ?? "") + "님!"
        super.init(nibName: nil, bundle: nil)
    }
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubView() {
        [subTitleLabel, titleLabel, userNameLabel].forEach {
            view.addSubview($0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            self?.coordinator?.didFinishAuth()
        }
    }
    
    override func layout() {
        subTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }
}
