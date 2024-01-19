//
//  SignUpOrderLabel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/01.
//

import UIKit

final class SignUpOrderLabel: UIStackView {
    private let numLabel = BaseLabel().then {
        $0.textAlignment = .center
        $0.clipsToBounds = true
        $0.backgroundColor = .primaryNormal
        $0.textColor = .white
        $0.font = .pretendard(.label5)
        $0.layer.cornerRadius = 10
    }
    
    private let titleLabel = BaseLabel().then {
        $0.textColor = .primaryNormal
        $0.font = .pretendard(.caption)
    }
    
    init(number: Int, title: String) {
        super.init(frame: .zero)
        numLabel.text = "\(number)"
        titleLabel.text = title
        
        setUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        [numLabel, titleLabel].forEach {
            addSubview($0)
        }
        
        numLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(numLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(numLabel)
            $0.trailing.equalToSuperview()
        }
    }
}
