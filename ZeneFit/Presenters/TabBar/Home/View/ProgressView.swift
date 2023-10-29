//
//  ProgressView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/29.
//

import UIKit

final class ProgressView: UIStackView {
    private let progressView = UIProgressView().then {
        $0.progressImage = .init(named: "ProgressColor")
        $0.backgroundColor = .lineNormal
        $0.layer.cornerRadius = 4
    }
    
    private let contentLabel = UILabel().then {
        $0.textColor = .textNormal
        $0.font = .pretendard(.chips)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        backgroundColor = .white
        layer.cornerRadius = 16
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(content: String, value: CGFloat) {
        self.contentLabel.text = content
        self.progressView.progress = Float(value)
    }
    
    private func setLayout() {
        [progressView, contentLabel].forEach {
            addSubview($0)
        }
        
        progressView.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview().inset(24)
            $0.height.equalTo(8)
        }
        
        contentLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(progressView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
}
