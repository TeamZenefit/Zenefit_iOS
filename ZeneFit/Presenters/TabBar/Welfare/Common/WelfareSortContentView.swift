//
//  WelfareSortContentView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/30/23.
//

import UIKit
import Combine

final class WelfareSortContentView: BaseView {
    private var cancellable = Set<AnyCancellable>()
    @Published var selectedSortType: WelfareSortType = .benefit
    @Published var isOpen: Bool = false
    
    private let benefitOrderButton = UIButton(type: .system).then {
        var configure = UIButton.Configuration.filled()
        configure.attributedTitle = .init("수혜금액순",
                                          attributes: .init([.font: UIFont.pretendard(.body2),
                                                             .foregroundColor : UIColor.white]))
        configure.baseBackgroundColor = .primaryNormal
        configure.background.cornerRadius = 16
        configure.background.strokeColor = .lineNormal
        configure.background.strokeWidth = 0
        configure.contentInsets = .init(top: 6, leading: 12, bottom: 6, trailing: 12)
        
        $0.configuration = configure
    }
    
    private let applyEndDateOrderButton = UIButton(type: .system).then {
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
        benefitOrderButton.tapPublisher
            .sink { [weak self] in
                self?.selectedSortType = .benefit
            }.store(in: &cancellable)
        
        applyEndDateOrderButton.tapPublisher
            .sink { [weak self] in
                self?.selectedSortType = .applyEndDate
            }.store(in: &cancellable)
        
        $selectedSortType
            .receive(on: RunLoop.main)
            .sink { [weak self] type in
                switch type {
                case .benefit:
                    self?.benefitOrderButton.configuration?.attributedTitle?.foregroundColor = UIColor.white
                    self?.benefitOrderButton.configuration?.baseBackgroundColor = .primaryNormal
                    self?.benefitOrderButton.configuration?.background.strokeWidth = 0
                    
                    self?.applyEndDateOrderButton.configuration?.attributedTitle?.foregroundColor = .textAlternative
                    self?.applyEndDateOrderButton.configuration?.baseBackgroundColor = .white
                    self?.applyEndDateOrderButton.configuration?.background.strokeWidth = 1
                    
                case .applyEndDate:
                    self?.benefitOrderButton.configuration?.attributedTitle?.foregroundColor = .textAlternative
                    self?.benefitOrderButton.configuration?.baseBackgroundColor = .white
                    self?.benefitOrderButton.configuration?.background.strokeWidth = 1
                    
                    self?.applyEndDateOrderButton.configuration?.attributedTitle?.foregroundColor = UIColor.white
                    self?.applyEndDateOrderButton.configuration?.baseBackgroundColor = .primaryNormal
                    self?.applyEndDateOrderButton.configuration?.background.strokeWidth = 0
                }
            }.store(in: &cancellable)
        
        $isOpen
            .receive(on: RunLoop.main)
            .sink { [weak self] isOpen in
                self?.benefitOrderButton.isHidden = !isOpen
                self?.applyEndDateOrderButton.isHidden = !isOpen
                
                let height = isOpen ? 56 : 12
                self?.snp.updateConstraints {
                    $0.height.equalTo(height)
                }
                
                self?.layoutIfNeeded()
            }.store(in: &cancellable)
    }
    
    override func addSubView() {
        [benefitOrderButton, applyEndDateOrderButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setLayout() {
        benefitOrderButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        applyEndDateOrderButton.snp.makeConstraints {
            $0.leading.equalTo(benefitOrderButton.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
    }
}
