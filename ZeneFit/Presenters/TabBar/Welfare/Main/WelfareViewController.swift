//
//  WelfareViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import UIKit

final class WelfareViewController: BaseViewController {
    weak var coordinator: WelfareCoordinator?
    private let testButton = UIButton(type: .system).then {
        $0.setTitle("테스트찾기", for: .normal)
        $0.setTitleColor(.textStrong, for: .normal)
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationItem.leftBarButtonItem = nil
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
