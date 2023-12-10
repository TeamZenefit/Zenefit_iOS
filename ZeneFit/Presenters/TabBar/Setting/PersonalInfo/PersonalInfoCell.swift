//
//  PersonalInfoCell.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/4/23.
//

import UIKit

final class PersonalInfoCell: UITableViewCell {
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(.body1)
        $0.textColor = .textNormal
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .pretendard(.label3)
        $0.textAlignment = .right
        $0.textColor = .textNormal
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(title: String, content: String) {
        titleLabel.text = title
        contentLabel.text = content
    }
    
    private func setLayout() {
        [titleLabel, contentLabel].forEach {
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
    }
    
}
