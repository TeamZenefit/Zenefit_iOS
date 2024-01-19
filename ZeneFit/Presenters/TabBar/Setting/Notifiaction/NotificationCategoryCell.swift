//
//  NotificationCategoryCell.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import UIKit

final class NotificationCategoryCell: UICollectionViewCell {
    
    private let titleLabel = BaseLabel().then {
        $0.font = .pretendard(.body2)
        $0.textColor = .textAssistive
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.lineNormal.cgColor
        backgroundColor = .white
        titleLabel.textColor = .textAlternative
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(8)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        layer.borderColor = UIColor.lineNormal.cgColor
        backgroundColor = .white
        titleLabel.textColor = .textAlternative
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(title: String, selectedCategory: String) {
        titleLabel.text = title
        if selectedCategory == title {
            layer.borderColor = UIColor.primaryNormal.cgColor
            titleLabel.textColor = .primaryNormal
            backgroundColor = .primaryNormal.withAlphaComponent(0.07)
        }
    }
}
