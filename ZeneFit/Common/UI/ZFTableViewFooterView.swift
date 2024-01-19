//
//  ZFFooterView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/02.
//

import UIKit

enum FooterType {
    case plain
    case fill
}

final class ZFTableViewFooterView: BaseView {
    private let type: FooterType
    
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
    
    private let guideLabel = BaseLabel().then {
        $0.text = "관심 정책은 달력에도 추가됩니다."
        $0.font = .pretendard(.chips)
        $0.textColor = .textAlternative
    }
    
    init(title: String, type: FooterType = .plain) {
        self.guideLabel.text = title
        self.type = type
        super.init(frame: .zero)
    }
    
    override func configureUI() {
        super.configureUI()
        
        backgroundColor = .clear
     
        if type == .fill {
            frameView.layer.cornerRadius = 0
        } else {
            frameView.layer.cornerRadius = 8
        }
    }
    
    override func addSubView() {
        addSubview(frameView)
        frameView.addSubview(stackView)
    }
    
    override func setLayout() {
        frameView.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.center.equalToSuperview()
            
            if type == .fill {
                $0.width.equalTo(UIScreen.main.bounds.width)
            } else {
                $0.width.equalTo(UIScreen.main.bounds.width-32)
            }
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
