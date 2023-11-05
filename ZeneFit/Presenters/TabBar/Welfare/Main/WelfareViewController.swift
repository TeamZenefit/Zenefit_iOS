//
//  WelfareViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import UIKit

final class WelfareViewController: BaseViewController {
    weak var coordinator: WelfareCoordinator?
    
    private let notiButton = UIButton(type: .system).then {
        $0.setImage(.init(named: "alarm_off"), for: .normal)
    }
    
    private let testButton = UIButton(type: .system).then {
        $0.setTitle("테스트찾기", for: .normal)
        $0.setTitleColor(.textStrong, for: .normal)
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        self.navigationController?.navigationBar.isHidden = false
        let titleLabel = UILabel().then {
            $0.text = "정책"
            $0.textColor = .textStrong
            $0.font = .pretendard(.label1)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = .init(customView: notiButton)
    }
    
    override func setupBinding() {
        testButton.tapPublisher
            .sink { [weak self] in
                self?.coordinator?.findWelfare()
            }.store(in: &cancellable)
    }

    override func addSubView() {
        [testButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func layout() {
        testButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
