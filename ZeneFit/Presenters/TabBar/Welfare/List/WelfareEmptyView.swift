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
        $0.text = "이 조건에는 받을 수 있는 정책이 없어요."
        $0.textColor = .textAlternative
        $0.font = .pretendard(.label1)
    }
    
    let contentLabel = UILabel().then {
        $0.text = "올바른 조건을 입력하셨는지 확인해주세요!"
        $0.textColor = .textAlternative
        $0.font = .pretendard(.body1)
    }
    
    let actionButton = UIButton().then {
        $0.setTitle("정책 찾아보기", for: .normal)
        $0.setTitleColor(.textAlternative, for: .normal)
        $0.layer.borderColor = UIColor.lineNormal.cgColor
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.titleLabel?.font = .pretendard(.body2)
    }
    
    init(image: UIImage = .init(resource: .noResult),
         title: String = "이 조건에는 받을 수 있는 정책이 없어요.",
         content: String = "올바른 조건을 입력하셨는지 확인해주세요!",
         action: (()->Void)? = nil) {
        super.init(frame: .zero)
        self.emptyImageView.image = image
        self.titleLabel.text = title
        self.contentLabel.text = content
        
        if let action = action {
            actionButton.isHidden = false
            actionButton.addAction(.init(handler: { _ in
                action()
            }), for: .touchUpInside)
        } else {
            actionButton.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        super.configureUI()
        self.backgroundColor = .white
    }
    
    override func addSubView() {
        [emptyImageView, titleLabel, contentLabel, actionButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setLayout() {
        emptyImageView.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.centerY).offset(-12)
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
        
        actionButton.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(36)
        }
    }
}
