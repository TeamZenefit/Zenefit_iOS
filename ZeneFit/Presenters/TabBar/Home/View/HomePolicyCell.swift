//
//  HomePolicyCell.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/16/24.
//

import UIKit

final class HomePolicyCell: UITableViewCell {
    private let policyImageView = UIImageView().then {
        $0.image = .init(named: "DefaultPolicy")
    }
    
    private let policyTypeLabel = UILabel().then {
        $0.textColor = .textAlternative
        $0.font = .pretendard(.chips)
    }
    
    private let policyNameLabel = UILabel().then {
        $0.textColor = .textNormal
        $0.font = .pretendard(.label3)
    }
    
    private let dateLabel = PaddingLabel(padding: .init(top: 6, left: 10, bottom: 6, right: 10)).then {
        $0.layer.masksToBounds = true
        $0.font = .pretendard(.label5)
        $0.isHidden = true
        $0.layer.cornerRadius = 14
        $0.textColor = .secondaryNormal
        $0.backgroundColor = .secondaryAssistive
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .white
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(item: PolicyDTO, showDate: Bool) {
        policyImageView.kf.setImage(with: URL(string: item.policyLogo),
                                    placeholder: UIImage(resource: .defaultPolicy))
        policyTypeLabel.text = item.supportPolicyTypeName
        policyNameLabel.text = item.policyName
        dateLabel.isHidden = !showDate
        
        if showDate {
            let dday = item.dueDate == 0 ? "D-day" : "D-\(item.dueDate)"
            dateLabel.text = dday
        }
    }
    
    private func setLayout() {
        [policyImageView, policyTypeLabel, policyNameLabel, dateLabel].forEach {
            addSubview($0)
        }
        
        policyImageView.snp.makeConstraints {
            $0.size.equalTo(42)
            $0.leading.equalToSuperview().offset(16)
            $0.verticalEdges.equalToSuperview().inset(8)
        }
        
        policyTypeLabel.snp.makeConstraints {
            $0.leading.equalTo(policyImageView.snp.trailing).offset(16)
            $0.top.equalTo(policyImageView)
        }
        
        policyNameLabel.snp.makeConstraints {
            $0.leading.equalTo(policyTypeLabel)
            $0.trailing.equalTo(dateLabel.snp.leading).offset(-16)
            $0.bottom.equalTo(policyImageView.snp.bottom)
        }
        
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        dateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
}
