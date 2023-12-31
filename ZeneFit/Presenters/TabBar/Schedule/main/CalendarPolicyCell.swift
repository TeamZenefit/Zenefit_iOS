//
//  CalendarPolicyCell.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/6/24.
//

import UIKit

final class CalendarPolicyCell: UITableViewCell {
    private let policyImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 21
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .textNormal
        $0.font = .pretendard(.label3)
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = .textAlternative
        $0.font = .pretendard(.chips)
    }
    
    private let applyButton = UIButton().then {
        var configure = UIButton.Configuration.filled()
        configure.attributedTitle = .init("신청하기",
                                          attributes: .init([.font : UIFont.pretendard(.label4),
                                                             .foregroundColor : UIColor.primaryNormal]))
        configure.baseBackgroundColor = .primaryAssistive
        configure.background.cornerRadius = 8
        configure.contentInsets = .init(top: 8, leading: 12, bottom: 8, trailing: 12)
        
        $0.configuration = configure
    }
    
    private let deleteButton = UIButton().then {
        var configure = UIButton.Configuration.filled()
        configure.attributedTitle = .init("삭제하기",
                                          attributes: .init([.font : UIFont.pretendard(.label4),
                                                             .foregroundColor : UIColor.white]))
        configure.baseBackgroundColor = .alert
        configure.background.cornerRadius = 8
        configure.contentInsets = .init(top: 8, leading: 12, bottom: 8, trailing: 12)
        
        $0.configuration = configure
        $0.isHidden = true
    }
                         
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        selectionStyle = .none
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(policy: CalendarPolicyDTO) {
        policyImageView.kf.setImage(with: URL(string: policy.policyAgencyLogo ?? ""),
                                    placeholder: UIImage(resource: .defaultPolicy))
        titleLabel.text = policy.policyName
        dateLabel.text = "\(policy.applySttDate) - \(policy.applyEndDate)"
    }
    
    private func setUI() {
        [policyImageView, titleLabel, dateLabel, applyButton, deleteButton].forEach {
            self.contentView.addSubview($0)
        }
        
        policyImageView.snp.makeConstraints {
            $0.size.equalTo(42)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(policyImageView.snp.trailing).offset(8)
            $0.top.equalTo(policyImageView)
            $0.trailing.equalTo(applyButton.snp.leading).offset(-16)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(policyImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(applyButton.snp.leading).offset(-16)
            $0.bottom.equalTo(policyImageView)
        }
        
        applyButton.setContentHuggingPriority(.required, for: .horizontal)
        applyButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(policyImageView)
        }
        
        deleteButton.setContentHuggingPriority(.required, for: .horizontal)
        deleteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(policyImageView)
        }
    }
}
