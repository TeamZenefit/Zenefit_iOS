//
//  PersonalInfoCell.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/4/23.
//

import UIKit

final class PersonalInfoCell: UITableViewCell {
    private let titleLabel = BaseLabel().then {
        $0.font = .pretendard(.body1)
        $0.textColor = .textNormal
    }
    
    private let contentLabel = BaseLabel().then {
        $0.font = .pretendard(.label3)
        $0.textAlignment = .right
        $0.textColor = .textNormal
    }
    
    private let switchView = UISwitch().then {
        $0.isHidden = true
        $0.onTintColor = .primaryNormal
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
    
    func configureCell(title: String, content: String? = nil, isOn: Bool? = nil) {
        titleLabel.text = title
        contentLabel.text = content
        if let isOn {
            contentLabel.text = isOn == true ? "네" : "아니오"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.isHidden = false
        switchView.isHidden = true
    }
    
    private func setLayout() {
        [titleLabel, contentLabel, switchView].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(16)
        }
        
        contentLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        switchView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
}
