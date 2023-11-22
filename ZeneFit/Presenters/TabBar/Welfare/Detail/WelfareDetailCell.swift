//
//  WelfareDetailCell.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/12/23.
//

import UIKit

final class WelfareDetailCell: UITableViewCell {
    static let identifier = "WelfareDetailCell"
    
    private let titleLabel = UILabel().then {
        $0.text = "제목"
        $0.font = .pretendard(.label3)
        $0.textColor = .textStrong
    }
    
    private let contentLabel = UILabel().then {
        $0.text = "내용"
        $0.numberOfLines = 0
        $0.font = .pretendard(.body1)
        $0.textColor = .textNormal
    }
    
    private let separatorLine = UIView().then {
        $0.backgroundColor = .lineNormal
    }
    
    private let applyTypeStackView = UIStackView().then {
        $0.spacing = 4
        $0.clipsToBounds = false
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
        clipsToBounds = false
        
        [titleLabel, contentLabel, separatorLine, applyTypeStackView].forEach {
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
        
        applyTypeStackView.snp.makeConstraints {
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
        applyTypeStackView.isHidden = true
        separatorLine.isHidden = false
    }
    
    func configureCell(title: String, content: String) {
        self.titleLabel.text = title
        self.contentLabel.text = content
    }
    
    func configureApplyTypeCell(title: String, content: String?, types: [String]) {
        self.titleLabel.text = title
        self.contentLabel.text = content
        
        separatorLine.isHidden = true
        applyTypeStackView.isHidden = false
        configureApplyType(types: types)
    }
    
    private func configureApplyType(types: [String]) {
        resetApplyType()
        
        types.forEach { type in
            let textColor: UIColor = type == "기간신청" ? .secondaryNormal : .primaryNormal
            let borderColor: UIColor = type == "기간신청" ? .secondaryAssistive : .primaryAssistive
            
            let label = PaddingLabel(padding: .init(top: 4, left: 8, bottom: 4, right: 8)).then {
                $0.clipsToBounds = true
                $0.text = type
                $0.font = .pretendard(.chips)
                $0.textColor = textColor
                $0.layer.cornerRadius = 12
                $0.layer.borderColor = borderColor.cgColor
                $0.layer.borderWidth = 1
            }
            
            applyTypeStackView.addArrangedSubview(label)
        }
    }
    
    private func resetApplyType() {
        applyTypeStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
