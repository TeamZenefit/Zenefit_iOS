//
//  BaseView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/05.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        addSubView()
        layout()
        setupBinding()
        setGesture()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.backgroundColor = .white
    }
    
    func addSubView() { }
    
    func layout() { }

    func setupBinding() { }
    
    func setGesture() { }
    
    func setDelegate() { }
}
