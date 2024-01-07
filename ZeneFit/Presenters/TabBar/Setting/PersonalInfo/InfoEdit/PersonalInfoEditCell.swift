//
//  PersonalInfoEditCell.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/7/24.
//

import UIKit

final class PersonalInfoEditCell: UITableViewCell {
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(.body1)
        $0.textColor = .textNormal
    }
    
    let contentTextField = InfoEditTextField().then {
        $0.textField.font = .pretendard(.label3)
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
        contentTextField.textField.text = content
        if let isOn {
            contentTextField.isHidden = true
            switchView.isHidden = false
            switchView.isOn = isOn
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentTextField.isHidden = false
        switchView.isHidden = true
    }
    
    private func setLayout() {
        [titleLabel, contentTextField, switchView].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(16)
        }
        
        contentTextField.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().offset(-16)
            $0.leading.equalTo(self.contentView.snp.centerX).offset(-20)
        }
        
        switchView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}
