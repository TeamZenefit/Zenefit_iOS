//
//  smallBoxView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/29.
//

import UIKit

final class SmallBoxView: UIView {
    private let titleLabel = UILabel().then {
        $0.textColor = .textNormal
        $0.font = .pretendard(.label5)
    }
    
    private let countLabel = UILabel().then {
        $0.textColor = .textNormal
        $0.font = .pretendard(.title1)
    }
    
    init(title: String) {
        titleLabel.text = title
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 8
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureInfo(count: Int) {
        countLabel.text = "\(count)개"
    }
    
    private func setLayout() {
        [titleLabel, countLabel].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(16)
        }
        
        countLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().offset(-24)
        }
    }
}
