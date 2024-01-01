//
//  WelfareEmptyView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/1/24.
//

import UIKit

final class WelfareEmptyView: BaseView {
    
    private let emptyImageView = UIImageView(image: .init(resource: .noResult)).then {
        $0.contentMode = .scaleAspectFit
    }
    
    let titleLabel = UILabel().then {
        $0.text = "받을 수 있는 정책이 없어요."
        $0.textColor = .textAlternative
        $0.font = .pretendard(.label1)
    }
    
    let contentLabel = UILabel().then {
        $0.text = "올바른 조건을 입력하셨는지 확인해주세요!"
        $0.textColor = .textAlternative
        $0.font = .pretendard(.body1)
    }

    override func configureUI() {
        super.configureUI()
        self.backgroundColor = .white
    }
    
    override func addSubView() {
        [emptyImageView, titleLabel, contentLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setLayout() {
        emptyImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(86)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }
}
