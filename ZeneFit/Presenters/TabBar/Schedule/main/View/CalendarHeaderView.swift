//
//  CalendarHeaderView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/6/24.
//

import Foundation
import FSCalendar

protocol CalendarHeaderDelegate: AnyObject {
    func tapPreviousMonth()
    func tapNextMonth()
}

final class CalendarHeaderView: UIView {
    weak var delegate: CalendarHeaderDelegate?
    
    let yearMonthLabel = UILabel().then {
        $0.textColor = .textStrong
        $0.font = .pretendard(.title1)
        $0.text = "text"
    }
    
    private let previousButton = UIButton().then {
        $0.setImage(.init(resource: .previous), for: .normal)
    }
    
    private let nextButton = UIButton().then {
        $0.setImage(.init(resource: .next), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        
        [yearMonthLabel, previousButton, nextButton].forEach {
            self.addSubview($0)
        }
        
        setLayout()
        
        previousButton.addAction(.init(handler: { [weak self] _ in
            guard let self else { return }
            delegate?.tapPreviousMonth()
        }), for: .touchUpInside)
        
        nextButton.addAction(.init(handler: { [weak self] _ in
            guard let self else { return }
            delegate?.tapNextMonth()
        }), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        yearMonthLabel.snp.makeConstraints {
            $0.verticalEdges.centerX.equalToSuperview()
        }
        
        previousButton.snp.makeConstraints {
            $0.trailing.equalTo(yearMonthLabel.snp.leading).offset(-40)
            $0.centerY.equalTo(yearMonthLabel)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.equalTo(yearMonthLabel.snp.trailing).offset(40)
            $0.centerY.equalTo(yearMonthLabel)
        }
    }
}
