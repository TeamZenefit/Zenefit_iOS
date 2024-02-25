//
//  LodingIndicatorView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/19.
//

import UIKit

enum IndicatorState {
    case active
    case inActive
}

final class LoadingIndicatorView: UIView {
    static var shared = LodingView()
    
    var state: IndicatorState = .inActive
    
    private let indicatorImageView = UIImageView(image: .init(resource: .indicator))
    
    static func showLoading() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.last,
                  let view = window.subviews.last else { return }

           
            if shared.state == .inActive {
                shared = LodingView()
                shared.frame = view.frame
                view.addSubview(shared)
                
                shared.startAnimation()
            }
        }
    }

    static func hideLoading() {
        DispatchQueue.main.async {
            shared.stopAnimation()
            shared.removeFromSuperview()
        }
    }
}

class LodingView: UIView {
    var state: IndicatorState = .inActive
    private let indicatorImageView = UIImageView(image: .init(resource: .indicator))
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white.withAlphaComponent(0.3)
        
        self.addSubview(indicatorImageView)
        
        self.indicatorImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        state = .inActive
        stopAnimation()
    }
    
    func startAnimation() {
        state = .active
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * Double.pi
        rotation.duration = 1.0
        rotation.repeatCount = .infinity
        indicatorImageView.layer.add(rotation, forKey: "spin")
    }

    func stopAnimation() {
        state = .inActive
        indicatorImageView.layer.removeAllAnimations()
    }
}

