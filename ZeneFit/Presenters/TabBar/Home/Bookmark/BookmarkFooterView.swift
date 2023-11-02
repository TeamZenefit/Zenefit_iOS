//
//  BookmarkFooterView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/02.
//

import UIKit

final class BookmarkFooterView: UIView {
    private let frameView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lineNormal.cgColor
    }
    
    private lazy var stackView = UIStackView()
    
    private let infoImageView = UIImageView().then {
        $0.image = UIImage(named: "InfoIcon")?.withRenderingMode(.alwaysOriginal)
    }
    
    private let guideLabel = UILabel().then {
        $0.text = "관심 정책은 달력에도 추가됩니다."
        $0.font = .pretendard(.chips)
        $0.textColor = .textAlternative
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(frameView)
        frameView.addSubview(stackView)
        
        [infoImageView, guideLabel].forEach {
            stackView.addSubview($0)
        }
        
        frameView.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
        }
        
        infoImageView.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview()
            $0.width.height.equalTo(18)
        }
        
        guideLabel.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.leading.equalTo(infoImageView.snp.trailing).offset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
