//
//  SelectionCell.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/01.
//

import UIKit

final class SelectionCell: UITableViewCell {
    static let identifier = "SelectionCell"
    
    private let titleLabel = UILabel().then {
        $0.textColor = .textNormal
        $0.font = .pretendard(.label3)
    }
    
    private let checkImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        [titleLabel, checkImage].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        checkImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-8)
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(item: String, isSelected: Bool) {
        titleLabel.text = item
        let image: UIImage? = isSelected ? UIImage(named: "Check") : nil
        checkImage.image = image
    }
}
