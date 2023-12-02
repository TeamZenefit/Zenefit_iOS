//
//  SettingMainCell.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import UIKit

final class SettingMainCell: UITableViewCell {
    private let titleLabel = UILabel().then {
        $0.textColor = .textNormal
        $0.font = .pretendard(.body1)
    }
    
    private let disclosureImageView = UIImageView().then {
        $0.image = .init(resource: .iNex26)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configuration(title: String) {
        titleLabel.text = title
    }
    
    private func setLayout() {
        [titleLabel, disclosureImageView].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(16)
        }
        
        disclosureImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
}

extension SettingMainCell {
    static func build(
        _ tableView: UITableView
    ) -> SettingMainCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingMainCell.identifier) as? SettingMainCell 
        else { return .init() }
        return cell
    }
}
