//
//  SettingHeaderView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import UIKit

final class SettingHeaderView: UIView {
    private let imageView = UIImageView()
    
    private let titleLabel = BaseLabel().then {
        $0.textColor = .textStrong
        $0.font = .pretendard(.label2)
    }
    
    init(with headerItem: HeaderModel) {
        super.init(frame: .zero)
        imageView.image = headerItem.image
        titleLabel.text = headerItem.title
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [imageView, titleLabel].forEach {
            addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.verticalEdges.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
    }
}
