//
//  HomePolicyInfoView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/29.
//

import UIKit

final class HomePolicyInfoView: UIStackView {
    static let identifier = "HomePolicyCell"
    
    private let mainImageView = UIImageView().then {
        $0.image = .init(named: "DefaultPolicy")
    }
    
    private let typeLabel = UILabel().then {
        $0.textColor = .textAlternative
        $0.font = .pretendard(.chips)
    }
    
    private let policyNameLabel = UILabel().then {
        $0.textColor = .textNormal
        $0.font = .pretendard(.label3)
    }
    
    private let applyButton = UIButton(type: .system).then {
        $0.titleLabel?.font = .pretendard(.label4)
        $0.backgroundColor = .primaryAssistive
        $0.setTitleColor(.primaryNormal, for: .normal)
        $0.setTitle("신청하기", for: .normal)
        $0.layer.cornerRadius = 8
    }
    
    private let dateLabel = PaddingLabel(padding: .init(top: 6, left: 10, bottom: 6, right: 10)).then {
        $0.layer.masksToBounds = true
        $0.font = .pretendard(.label5)
        $0.isHidden = true
        $0.layer.cornerRadius = 14
        $0.textColor = .secondaryNormal
        $0.backgroundColor = .secondaryAssistive
    }
    
    init(type: String?, title: String, image: String?, dday: Int, hasDday: Bool) {
        self.typeLabel.text = type
        self.policyNameLabel.text = title
        self.mainImageView.kf.setImage(with: URL(string: image ?? ""))
        if hasDday {
            applyButton.isHidden = true
            dateLabel.isHidden = false
            if dday > 0 {
                dateLabel.text = "D-\(dday)"
            } else {
                dateLabel.text = "D-Day"
            }
        }
        super.init(frame: .zero)
        setNeedsLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setNeedsLayout() {
        [mainImageView, typeLabel, policyNameLabel, applyButton, dateLabel].forEach {
            addSubview($0)
        }
        
        mainImageView.snp.makeConstraints {
            $0.width.height.equalTo(42)
            $0.leading.equalToSuperview()
            $0.verticalEdges.equalToSuperview().inset(8)
        }
        
        typeLabel.snp.makeConstraints {
            $0.leading.equalTo(mainImageView.snp.trailing).offset(16)
            $0.top.equalTo(mainImageView).offset(1)
        }
        
        applyButton.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.height.equalTo(36)
            $0.width.equalTo(73)
        }
        
        policyNameLabel.snp.makeConstraints {
            $0.leading.equalTo(typeLabel)
            $0.trailing.equalTo(applyButton.snp.leading).offset(-16)
            $0.top.equalTo(typeLabel.snp.bottom).offset(2)
        }
        
        dateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
