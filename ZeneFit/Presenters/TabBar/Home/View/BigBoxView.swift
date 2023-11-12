//
//  BigBoxView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/29.
//

import UIKit

final class BigBoxView: UIStackView {
    
    private let titleLabel = UILabel().then {
        $0.textColor = .textNormal
        $0.font = .pretendard(.label2)
    }
    
    private let disclosureButton = UIButton().then {
        $0.setImage(.init(named: "i-nex-26")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private let separatorLineView = UIView().then {
        $0.backgroundColor = .lineAlternative
    }
    
    private let itemStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    init(title: String) {
        self.titleLabel.text = title
        super.init(frame: .zero)
        setLayout()
        
        layer.cornerRadius = 16
        backgroundColor = .white
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setItems(items: [PolicyDTO]) {
        resetItems()
        
        for item in items {
            let view = HomePolicyInfoView(type: item.supportPolicyTypeName,
                                          title: item.policyName,
                                          image: item.policyLogo,
                                          date: item.endDate)
            itemStackView.addArrangedSubview(view)
        }
        self.layoutIfNeeded()
    }
    
    private func resetItems() {
        for subview in itemStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
    }
    
    private func setLayout() {
        [titleLabel, separatorLineView, disclosureButton, itemStackView].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(16)
        }
        
        disclosureButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(titleLabel)
        }
        
        separatorLineView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.height.equalTo(1)
        }
        
        itemStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(separatorLineView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}