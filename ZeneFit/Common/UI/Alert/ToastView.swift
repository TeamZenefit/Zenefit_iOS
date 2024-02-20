//
//  ToastView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/19.
//

import UIKit

final class ToastView: UIStackView {
    static var currentToast: [(String, ToastView)] = []
    
    private var workItem: DispatchWorkItem?
    
    private lazy var showAnimation = UIViewPropertyAnimator(duration: 0.7, curve: .easeInOut) { [weak self] in
        self?.transform = CGAffineTransform.identity
    }
    
    private lazy var hideAnimation = UIViewPropertyAnimator(duration: 0.7, curve: .easeInOut) { [weak self] in
        self?.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
    }
    
    private let contentLabel = BaseLabel().then {
        $0.font = .pretendard(.label3)
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    init(_ content: String) {
        super.init(frame: .zero)
        //        self.frame.origin = .init(x: 0, y: UIScreen.main.bounds.height)

        self.contentLabel.text = content
        
        setLayout()
        configureUI()
        show(message: content)
        configureAnimation()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.addSubview(self.contentLabel)
        
        self.contentLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    private func configureUI() {
        self.backgroundColor = .textNormal.withAlphaComponent(0.7)
        self.layer.cornerRadius = 8
        
        self.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
    }
    
    private func configureAnimation() {
        // 토스트가 사라진 후에는 제거
        hideAnimation.addCompletion { [weak self] _ in
            ToastView.currentToast.removeAll(where: { $0.1 === self })
            self?.removeFromSuperview()
        }
    }
    
    static func showToast(_ message: String) {
        guard let windowScene = UIApplication.shared.scene,
              let view = windowScene.windows.last?.subviews.last else { return }
        
        let toast = Self(message)
        view.addSubview(toast)
        
        toast.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
    
    private func show(message: String) {
        if let existedToast = ToastView.currentToast.first(where: { $0.0 == message }) {
            existedToast.1.removeFromSuperview()
            ToastView.currentToast.removeAll(where: { $0.1 === existedToast.1 })
            self.transform = .identity
            self.hideAnimation.startAnimation(afterDelay: 1.2)
        } else {
            showAnimation.startAnimation()
            hideAnimation.startAnimation(afterDelay: 1.4)
            ToastView.currentToast.append((message, self))
        }
        ToastView.currentToast.append((message, self))
    }
}
