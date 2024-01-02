//
//  StandardNotificationAlertView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/19.
//

import UIKit

final class StandardNotificationAlertView: UIStackView {
    
    private let contentLabel = UILabel().then {
        $0.font = .pretendard(.label3)
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    init(_ content: String) {
        super.init(frame: .zero)
        self.addSubview(self.contentLabel)
        self.frame.origin = .init(x: 0, y: UIScreen.main.bounds.height)
        
        self.contentLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        self.contentLabel.text = content
        self.backgroundColor = .textNormal.withAlphaComponent(0.7)
        self.layer.cornerRadius = 8
        
        show()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func show() {
        // 화면 아래에서 시작
        self.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            // 화면 위로 이동
            self.transform = CGAffineTransform.identity
        }) { _ in
            // 0.7초 후에 사라지기
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                UIView.animate(withDuration: 0.7, animations: {
                    // 화면 아래로 이동하여 사라지기
                    self.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
                }) { _ in
                    // 토스트가 사라진 후에는 제거
                    self.removeFromSuperview()
                }
            }
        }
    }
}
