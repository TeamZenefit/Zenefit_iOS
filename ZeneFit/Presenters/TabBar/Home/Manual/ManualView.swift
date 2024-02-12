//
//  OnboardingView.swift
//  FitHub
//
//  Created by iOS신상우 on 2023/08/24.
//

import UIKit

final class ManualView: UIView {
    private let titleLabel = BaseLabel().then {
        $0.font = .pretendard(.label1)
        $0.textColor = .textNormal
    }
    
    private let subTitleLabel = BaseLabel().then {
        $0.font = .pretendard(.body1)
        $0.textColor = .textAlternative
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let deviceImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    init(title: String, subTitle: String, image: UIImage?) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
        self.deviceImageView.image = image
        
        [titleLabel, subTitleLabel, deviceImageView].forEach {
            self.addSubview($0)
        }
        
        deviceImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(deviceImageView.snp.bottom).offset(24)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
