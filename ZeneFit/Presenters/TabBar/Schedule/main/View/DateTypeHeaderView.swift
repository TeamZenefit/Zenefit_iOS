//
//  DateTypeHeaderView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/20/24.
//

import UIKit

final class DateTypeHeaderView: BaseView {
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(.chips)
        $0.textColor = .textAlternative
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .lineNormal
    }
    
    init(title: String) {
        titleLabel.text = title
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubView() {
        [titleLabel, separatorView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-4)
        }
        
        separatorView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.height.equalTo(1)
        }
    }
}
