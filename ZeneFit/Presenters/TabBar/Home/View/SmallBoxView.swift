//
//  smallBoxView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/29.
//

import UIKit

final class SmallBoxView: UIView {
    private let iconImageView = UIImageView()
    
    private let titleLabel = UILabel().then {
        $0.textColor = .textNormal
        $0.font = .pretendard(.label3)
    }
    
    private let countLabel = UILabel().then {
        $0.textColor = .textStrong
        $0.font = .pretendard(.label2)
    }
    
    init(title: String, icon: UIImage) {
        titleLabel.text = title
        iconImageView.image = icon
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
        [iconImageView, titleLabel, countLabel].forEach {
            addSubview($0)
        }
        
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
            $0.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(2)
            $0.centerY.equalTo(iconImageView)
        }
        
        countLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}
