//
//  DefaultErrorViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/31/23.
//

import UIKit
import Combine

final class DefaultErrorView: BaseView {
    private var cancellable = Set<AnyCancellable>()
    
    var retryHandler: (()->Void)?
    
    private let errorImageView = UIImageView(image: .init(resource: .errorIcon)).then {
        $0.contentMode = .scaleAspectFit
    }
    
    let titleLabel = UILabel().then {
        $0.text = "인터넷 연결이 불안정합니다."
        $0.textColor = .textAlternative
        $0.font = .pretendard(.label1)
    }
    
    let contentLabel = UILabel().then {
        $0.text = "인터넷 연결이 불안정합니다. 다시 시도해주세요."
        $0.textColor = .textAlternative
        $0.font = .pretendard(.body1)
    }
    
    private let retryButton = UIButton(type: .system).then {
        var configure = UIButton.Configuration.filled()
        configure.image = .init(resource: .iRe220)
        configure.baseBackgroundColor = .white
        configure.background.cornerRadius = 4
        configure.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        configure.imagePadding = 8
        configure.imagePlacement = .trailing
        configure.background.strokeWidth = 1
        configure.background.strokeColor = .lineNormal
        configure.attributedTitle = .init("다시 시도",
                                          attributes: .init([
                                            .font : UIFont.pretendard(.body2),
                                            .foregroundColor : UIColor.textAlternative
                                          ]))
        
        $0.configuration = configure
    }
    
    override func configureUI() {
        super.configureUI()
        self.backgroundColor = .backgroundPrimary
    }
    
    override func setupBinding() {
        retryButton.tapPublisher
            .sink { [weak self] in
                self?.retryHandler?()
            }.store(in: &cancellable)
    }
    
    override func addSubView() {
        [errorImageView, titleLabel, contentLabel, retryButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setLayout() {
        errorImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(97)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(errorImageView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        retryButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(contentLabel.snp.bottom).offset(16)
        }
    }
}
