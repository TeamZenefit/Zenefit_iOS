//
//  WelfareSortContentView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/30/23.
//

import UIKit
import Combine

enum WelfareSortType {
    case closing
    case amount
    
    var description: String {
        switch self {
        case .amount: "수혜금액"
        case .closing: "마감순"
        }
    }
}

final class WelfareSortContentView: BaseView {
    private var cancellable = Set<AnyCancellable>()
    @Published var selectedSortType: WelfareSortType = .amount
    @Published var isOpen: Bool = false
    
    private let amountOrder = UIButton(type: .system).then {
        var configure = UIButton.Configuration.filled()
        configure.attributedTitle = .init("수혜금액",
                                          attributes: .init([.font: UIFont.pretendard(.body2),
                                                             .foregroundColor : UIColor.white]))
        configure.baseBackgroundColor = .primaryNormal
        configure.background.cornerRadius = 16
        configure.background.strokeColor = .lineNormal
        configure.background.strokeWidth = 0
        configure.contentInsets = .init(top: 6, leading: 12, bottom: 6, trailing: 12)
        
        $0.configuration = configure
    }
    
    private let closingOrder = UIButton(type: .system).then {
        var configure = UIButton.Configuration.filled()
        configure.attributedTitle = .init("마감순",
                                          attributes: .init([.font: UIFont.pretendard(.body2),
                                                             .foregroundColor : UIColor.textAlternative]))
        configure.baseBackgroundColor = .white
        configure.background.cornerRadius = 16
        configure.background.strokeColor = .lineNormal
        configure.background.strokeWidth = 1
        configure.contentInsets = .init(top: 6, leading: 12, bottom: 6, trailing: 12)
        
        $0.configuration = configure
    }
    
    override func setupBinding() {
        amountOrder.tapPublisher
            .sink { [weak self] in
                self?.selectedSortType = .amount
            }.store(in: &cancellable)
        
        closingOrder.tapPublisher
            .sink { [weak self] in
                self?.selectedSortType = .closing
            }.store(in: &cancellable)
        
        $selectedSortType
            .receive(on: RunLoop.main)
            .sink { [weak self] type in
                switch type {
                case .amount:
                    self?.amountOrder.configuration?.attributedTitle?.foregroundColor = UIColor.white
                    self?.amountOrder.configuration?.baseBackgroundColor = .primaryNormal
                    self?.amountOrder.configuration?.background.strokeWidth = 0
                    
                    self?.closingOrder.configuration?.attributedTitle?.foregroundColor = .textAlternative
                    self?.closingOrder.configuration?.baseBackgroundColor = .white
                    self?.closingOrder.configuration?.background.strokeWidth = 1
                    
                case .closing:
                    self?.amountOrder.configuration?.attributedTitle?.foregroundColor = .textAlternative
                    self?.amountOrder.configuration?.baseBackgroundColor = .white
                    self?.amountOrder.configuration?.background.strokeWidth = 1
                    
                    self?.closingOrder.configuration?.attributedTitle?.foregroundColor = UIColor.white
                    self?.closingOrder.configuration?.baseBackgroundColor = .primaryNormal
                    self?.closingOrder.configuration?.background.strokeWidth = 0
                }
            }.store(in: &cancellable)
        
        $isOpen
            .receive(on: RunLoop.main)
            .sink { [weak self] isOpen in
                self?.amountOrder.isHidden = !isOpen
                self?.closingOrder.isHidden = !isOpen
                
                let height = isOpen ? 56 : 12
                self?.snp.updateConstraints {
                    $0.height.equalTo(height)
                }
                
                self?.layoutIfNeeded()
            }.store(in: &cancellable)
    }
    
    override func addSubView() {
        [amountOrder, closingOrder].forEach {
            self.addSubview($0)
        }
    }
    
    override func setLayout() {
        amountOrder.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        closingOrder.snp.makeConstraints {
            $0.leading.equalTo(amountOrder.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
    }
}
