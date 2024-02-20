//
//  LodingIndicatorView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/19.
//

import UIKit

final class LoadingIndicatorView {
    static var loadingIndicatorView: LodingView?
    
    static func showLoading() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.last,
                  let view = window.subviews.first else { return }

            
            if let existedView = window.subviews.first(where: { $0 is LodingView } ) as? LodingView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = LodingView()
                loadingIndicatorView?.frame = view.frame
                view.addSubview(loadingIndicatorView!)
                
                loadingIndicatorView?.startAnimation()
            }
        }
    }

    static func hideLoading() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
            
            loadingIndicatorView?.stopAnimation()
            loadingIndicatorView = nil
        }
    }
}

class LodingView: UIView {
    
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
        stopAnimation()
    }
    
    func startAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * Double.pi
        rotation.duration = 1.0
        rotation.repeatCount = .infinity
        indicatorImageView.layer.add(rotation, forKey: "spin")
    }

    func stopAnimation() {
        indicatorImageView.layer.removeAllAnimations()
    }
}

