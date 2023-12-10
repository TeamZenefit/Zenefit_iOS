//
//  ZFFooterView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/02.
//

import UIKit

final class ZFTableViewFooterView: UIView {
    private let frameView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lineNormal.cgColor
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [infoImageView, guideLabel]).then {
        $0.distribution = .fillProportionally
        $0.spacing = 8
    }
    
    private let infoImageView = UIImageView().then {
        $0.image = UIImage(named: "InfoIcon")?.withRenderingMode(.alwaysOriginal)
    }
    
    private let guideLabel = UILabel().then {
        $0.text = "관심 정책은 달력에도 추가됩니다."
        $0.font = .pretendard(.chips)
        $0.textColor = .textAlternative
    }
    
    init(title: String) {
        guideLabel.text = title
        super.init(frame: .zero)
        
        addSubview(frameView)
        frameView.addSubview(stackView)
        
        frameView.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.width.equalTo(UIScreen.main.bounds.width-32)
            $0.center.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.verticalEdges.equalToSuperview().inset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
