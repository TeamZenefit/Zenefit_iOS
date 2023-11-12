//
//  CategoryCell.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/08.
//

import UIKit

final class CategoryCell: UICollectionViewCell {
    static let identifier = "CategoryCell"
    
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(.label3)
        $0.textColor = .textAssistive
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 20
        backgroundColor = .white
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(8)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .white
        titleLabel.textColor = .textAssistive
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(title: String, selectedCategory: String) {
        titleLabel.text = title
        if selectedCategory == title {
            backgroundColor = .textNormal
            titleLabel.textColor = .white
        }
    }
}
