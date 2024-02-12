//
//  CalendarCell.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2/4/24.
//

import Foundation
import FSCalendar


// 기존 appearance clear처리하고 커스텀해야함
final class CalendarCell: FSCalendarCell {
    private let dayLabel = UILabel().then {
        $0.textColor = .red
        $0.font = .pretendard(.body1)
    }
    
    override init!(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dayLabel)
        
        dayLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureCell(date: Date) {
        subtitleLabel.text = "123"
        dayLabel.text = "\(date.day)"
        dayLabel.textColor = .red
    }
}
