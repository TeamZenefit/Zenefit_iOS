//
//  GenderSelectionView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/21/24.
//

import UIKit
import Combine

enum GenderType: String {
    case male = "남성"
    case female = "여성"
}

class GenderSelectionView: UIStackView {
    private var cancellable = Set<AnyCancellable>()
    
    var changedGender: ((GenderType)->Void)?
    
    var gender: GenderType = .male {
        didSet {
            switch gender {
            case .female:
                maleButton.isSelected = false
                femaleButton.isSelected = true
            case .male:
                maleButton.isSelected = true
                femaleButton.isSelected = false
            }
        }
    }
    
    private lazy var maleButton = UIButton().then {
        var configure = UIButton.Configuration.filled()
        configure.background.cornerRadius = 16
        configure.background.strokeColor = .lineNormal
        configure.contentInsets = .init(top: 6, leading: 12, bottom: 6, trailing: 12)
        $0.configurationUpdateHandler = {
            switch $0.state {
            case .selected:
                $0.configuration?.baseBackgroundColor = .primaryNormal
                $0.configuration?.attributedTitle = .init(
                    "남성",
                    attributes:.init( [.font : UIFont.pretendard(.body2),
                                       .foregroundColor: UIColor.white])
                )
                $0.configuration?.background.strokeWidth = 0
            default:
                $0.configuration?.baseBackgroundColor = .white
                $0.configuration?.attributedTitle = .init(
                    "남성",
                    attributes:.init( [.font : UIFont.pretendard(.body2),
                                       .foregroundColor: UIColor.textAlternative])
                )
                $0.configuration?.background.strokeWidth = 1
            }
        }
        $0.configuration = configure
    }
    
    private lazy var femaleButton = UIButton().then {
        var configure = UIButton.Configuration.filled()
        configure.background.cornerRadius = 16
        configure.background.strokeColor = .lineNormal
        configure.contentInsets = .init(top: 6, leading: 12, bottom: 6, trailing: 12)
        $0.configurationUpdateHandler = {
            switch $0.state {
            case .selected:
                $0.configuration?.baseBackgroundColor = .primaryNormal
                $0.configuration?.attributedTitle = .init(
                    "여성",
                    attributes:.init( [.font : UIFont.pretendard(.body2),
                                       .foregroundColor: UIColor.white])
                )
                $0.configuration?.background.strokeWidth = 0
            default:
                $0.configuration?.baseBackgroundColor = .white
                $0.configuration?.attributedTitle = .init(
                    "여성",
                    attributes:.init( [.font : UIFont.pretendard(.body2),
                                       .foregroundColor: UIColor.textAlternative])
                )
                $0.configuration?.background.strokeWidth = 1
            }
        }

        $0.configuration = configure
    }
    
    init() {
        super.init(frame: .zero)
        
        addArrangedSubview(maleButton)
        addArrangedSubview(femaleButton)
        
        distribution = .fillEqually
        spacing = 8
        
        bind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        maleButton.tapPublisher
            .sink { [weak self] in
                self?.gender = .male
                self?.changedGender?(.male)
            }.store(in: &cancellable)
        
        femaleButton.tapPublisher
            .sink { [weak self] in
                self?.gender = .female
                self?.changedGender?(.female)
            }.store(in: &cancellable)
    }
}
