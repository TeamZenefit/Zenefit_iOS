//
//  EventGuideView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/6/24.
//

import UIKit

final class EventGuideView: UIView {
    private let eventDotImage = UIImageView().then {
        $0.image = .init(resource: .eventDot)
    }
    
    private let eventGuideLabel = UILabel().then {
        $0.text = "신청 일정"
        $0.textColor = .textNormal
        $0.font = .pretendard(.chips)
    }
    
    private let todayDotImage = UIImageView().then {
        $0.image = .init(resource: .todayDot)
    }
    
    private let todayGuideLabel = UILabel().then {
        $0.text = "오늘"
        $0.textColor = .textNormal
        $0.font = .pretendard(.chips)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        [eventDotImage, todayDotImage, eventGuideLabel, todayGuideLabel].forEach {
            self.addSubview($0)
        }
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        eventDotImage.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(eventGuideLabel)
        }
        
        eventGuideLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(eventDotImage.snp.trailing).offset(4)
        }
        
        todayDotImage.snp.makeConstraints {
            $0.leading.equalTo(eventGuideLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(eventGuideLabel)
        }
        
        todayGuideLabel.snp.makeConstraints {
            $0.leading.equalTo(todayDotImage.snp.trailing).offset(4)
            $0.centerY.equalTo(eventGuideLabel)
            $0.trailing.equalToSuperview()
        }
    }
    
    
}
