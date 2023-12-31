//
//  StandardNotificationAlertView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/19.
//

import UIKit

final class StandardNotificationAlertView: UIStackView {
    private var delayedExecutionWorkItem: DispatchWorkItem?
    
    private let contentLabel = UILabel().then {
        $0.font = .pretendard(.label3)
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    init(_ content: String) {
        super.init(frame: .zero)
        self.addSubview(self.contentLabel)
        
        self.contentLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        self.contentLabel.text = content
        self.backgroundColor = .textNormal.withAlphaComponent(0.7)
        self.layer.cornerRadius = 8
        
        delayedExecutionWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            UIView.animate(withDuration: 0.7, animations: {
                self.frame.origin = .init(x: 16, y: UIScreen.main.bounds.height)
            }) { _ in
                self.removeFromSuperview()
            }
        }
        
        // 0.6초 후에 클로저를 실행
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: workItem)
        
        // 현재 작업 항목을 저장 ( 추후 슈퍼뷰 탭 이벤트시 취소 기능 추가 가능성 )
        self.delayedExecutionWorkItem = workItem
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
