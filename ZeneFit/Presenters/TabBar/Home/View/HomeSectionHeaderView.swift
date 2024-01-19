//
//  HomeSectionHeaderView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/16/24.
//

import UIKit
import Combine

final class HomeSectionHeaderView: BaseView {
    private lazy var cancellable = Set<AnyCancellable>()
    
    var tapEventHandler: (()->Void)?
    
    private let titleLabel = BaseLabel().then {
        $0.textColor = .textNormal
        $0.font = .pretendard(.label2)
    }
    
    private let disclosureButton = UIButton().then {
        $0.setImage(.init(named: "i-nex-26")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private let separatorLineView = UIView().then {
        $0.backgroundColor = .lineAlternative
    }
    
    init(title: String,
         action: (()->Void)?) {
        self.titleLabel.text = title
        self.tapEventHandler = action
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        super.configureUI()
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundColor = .white
    }
    
    override func setupBinding() {
        self.gesturePublisher(for: .tap)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tapEventHandler?()
            }.store(in: &cancellable)
    }
    
    override func addSubView() {
        [titleLabel, disclosureButton, separatorLineView].forEach {
            addSubview($0)
        }
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        disclosureButton.snp.makeConstraints {
            $0.size.equalTo(26)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        separatorLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
    }
}
