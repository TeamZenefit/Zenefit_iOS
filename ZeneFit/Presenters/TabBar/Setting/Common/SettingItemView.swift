//
//  SettingItemView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import UIKit

final class SettingItemView: BaseView {
    private let titleLabel = BaseLabel().then {
        $0.textColor = .textNormal
        $0.font = .pretendard(.body1)
    }
    
    private let contentLabel = BaseLabel().then {
        $0.textColor = .textNormal
        $0.font = .pretendard(.label3)
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [contentLabel, disclosureImageView])
    
    private let disclosureImageView = UIImageView().then {
        $0.image = .init(resource: .iNex26)
    }
    
    var isHiddenContent: Bool = false {
        didSet {
            contentLabel.isHidden = isHiddenContent
        }
    }
    
    var isHiddenDisclosure: Bool = false {
        didSet {
            disclosureImageView.isHidden = isHiddenDisclosure
        }
    }
    
    var contentTextColor: UIColor = .textNormal {
        didSet {
            contentLabel.textColor = contentTextColor
        }
    }
    
    var contentTextFont: UIFont = .pretendard(.label3) {
        didSet {
            contentLabel.font = contentTextFont
        }
    }
    
    var disclosureColor: UIColor = .textAlternative {
        didSet {
            self.disclosureImageView.image = .init(resource: .iNex26).withTintColor(disclosureColor)
        }
    }
    
    init(title: String, content: String? = nil) {
        self.titleLabel.text = title
        self.contentLabel.text = content
        super.init(frame: .zero)
    }
    
    override func addSubView() {
        [titleLabel, stackView].forEach {
            addSubview($0)
        }
    }
    
    func setContent(content: String) {
        DispatchQueue.main.async {
            self.contentLabel.text = content
        }
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(16)
        }
        
        stackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
