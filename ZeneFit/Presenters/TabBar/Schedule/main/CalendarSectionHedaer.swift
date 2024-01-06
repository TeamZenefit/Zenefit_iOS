//
//  CalendarSectionHedaer.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/6/24.
//

import UIKit

final class CalendarSectionHedaer: UIView {
    private let monthLabel = UILabel().then {
        $0.textColor = .textStrong
        $0.font = .pretendard(.label2)
    }
    
    private let editButton = UIButton().then {
        $0.setImage(.init(resource: .iWr28), for: .normal)
        $0.setImage(.init(resource: .iWr28Del), for: .selected)
    }
    
    private let policyCountLabel = UILabel().then {
        $0.font = .pretendard(.label5)
        $0.textColor = .textAssistive
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .lineNormal
    }
    
    var count: String? {
        get { policyCountLabel.text }
        set { policyCountLabel.text = "총 \(newValue ?? "0")건"}
    }
    
    var month: String? {
        get { monthLabel.text }
        set { monthLabel.text = "\(newValue ?? "-")월 일정"}
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        [monthLabel, editButton, policyCountLabel, separatorView].forEach {
            self.addSubview($0)
        }
        
        monthLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(20)
        }
        
        editButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.size.equalTo(26)
            $0.centerY.equalTo(monthLabel)
        }
        
        policyCountLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(monthLabel.snp.bottom).offset(20)
        }
        
        separatorView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(1)
            $0.width.equalTo(UIScreen.main.bounds.width-32)
            $0.top.equalTo(policyCountLabel.snp.bottom).offset(4)
            $0.bottom.equalToSuperview()
        }
    }
}
