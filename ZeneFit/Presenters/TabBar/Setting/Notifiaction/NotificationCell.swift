//
//  NotificationCell.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import UIKit

final class NotificationCell: UITableViewCell {
    private let iconImageView = UIImageView()
    
    private let titleLabel = BaseLabel().then {
        $0.font = .pretendard(.label3)
        $0.textColor = .textNormal
    }
    
    private let contentLabel = BaseLabel().then {
        $0.font = .pretendard(.body1)
        $0.textColor = .textNormal
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .lineAlternative
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        backgroundColor = .white
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(item: NotificationInfo) {
        titleLabel.text = item.title
        contentLabel.text = item.content
        iconImageView.kf.setImage(with: URL(string: item.logo))
    }
    
    private func setLayout() {
        [iconImageView, titleLabel, contentLabel, dividerView].forEach {
            addSubview($0)
        }
        
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(24)
            $0.size.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(16)
            $0.top.equalToSuperview().offset(24)
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
            $0.top.equalTo(contentLabel.snp.bottom).offset(24)
            $0.bottom.equalToSuperview()
        }
    }
}
