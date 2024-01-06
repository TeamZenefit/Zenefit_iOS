//
//  NotiSettingItemView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import UIKit

final class NotiSettingItemView: BaseView {
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(.body1)
        $0.textColor = .textNormal
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = .pretendard(.chips)
        $0.textColor = .textAlternative
    }
    
    let notiSwitch = UISwitch().then {
        $0.onTintColor = .primaryNormal
    }
    
    var isOn: Bool {
        set {
            notiSwitch.isOn = newValue
        }
        
        get {
            notiSwitch.isOn
        }
    }
    
    init(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubView() {
        [titleLabel, subTitleLabel, notiSwitch].forEach {
            addSubview($0)
        }
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(12)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        notiSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-22)
            $0.centerY.equalToSuperview()
        }
    }
}
