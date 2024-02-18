//
//  WelfareDetailCell.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/12/23.
//

import UIKit

/// <#Description#>
final class WelfareDetailCell: UITableViewCell {
    
    private let titleLabel = BaseLabel().then {
        $0.text = "제목"
        $0.font = .pretendard(.label3)
        $0.textColor = .textStrong
    }
    
    private let contentLabel = BaseLabel().then {
        $0.text = "내용"
        $0.numberOfLines = 0
        $0.font = .pretendard(.body1)
        $0.textColor = .textNormal
    }
    
    private let separatorLine = UIView().then {
        $0.backgroundColor = .lineNormal
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
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - style: <#style description#>
    ///   - reuseIdentifier: <#reuseIdentifier description#>
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
        clipsToBounds = false
        
        [titleLabel, contentLabel, separatorLine, dateTypeLabel].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
        }
        
        dateTypeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(titleLabel)
        }
        
        separatorLine.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateTypeLabel.isHidden = true
        separatorLine.isHidden = false
    }
    
    func configureCell(title: String, content: String) {
        self.titleLabel.text = title
        self.contentLabel.text = content
    }
    
    func configureApplyTypeCell(title: String, content: String?, type: String) {
        self.titleLabel.text = title
        self.contentLabel.text = content
        
        separatorLine.isHidden = true
        dateTypeLabel.isHidden = false
        
        configureDateType(type: PolicyDateType(rawValue: type) ?? .blank)
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
