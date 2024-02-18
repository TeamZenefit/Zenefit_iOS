//
//  WelfareDetailDateTypeCell.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2/13/24.
//

import UIKit

final class WelfareDetailDateTypeCell: UITableViewCell {
    
    private let titleLabel = BaseLabel().then {
        $0.text = "제목"
        $0.font = .pretendard(.label3)
        $0.textColor = .textStrong
    }
    
    private let dateTypeLabel =  PaddingLabel(vPadding: 4, hPadding: 8).then {
        $0.isSkeletonable = true
        $0.clipsToBounds = true
        $0.font = .pretendard(.chips)
        $0.textColor = .secondaryNormal
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.secondaryAssistive.cgColor
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
        clipsToBounds = false
        
        [titleLabel, dateTypeLabel].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(12)
        }
        
        dateTypeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(titleLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(title: String, dateType: PolicyDateType) {
        titleLabel.text = title
        configureDateType(type: dateType)
    }
    
    private func configureDateType(type: PolicyDateType) {
        let textColor: UIColor = self.isSelected ? .textDisable : .secondaryNormal
        let borderColor: UIColor = self.isSelected ? .lineAlternative : .secondaryAssistive
        
        dateTypeLabel.text = type.description
        dateTypeLabel.isHidden = type == .blank || type == .undecided
        dateTypeLabel.textColor = textColor
        dateTypeLabel.layer.borderColor = borderColor.cgColor
    }
}
