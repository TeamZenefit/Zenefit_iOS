//
//  HomeSectionFooterView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/16/24.
//

import UIKit

final class HomeSectionFooterView: BaseView {
    let bottomFrameView = UIView().then {
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        $0.backgroundColor = .white
    }
    
    override func configureUI() {
        backgroundColor = .clear
    }
    
    override func addSubView() {
        [bottomFrameView].forEach {
            addSubview($0)
        }
    }
    
    override func setLayout() {
        bottomFrameView.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.height.equalTo(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}
