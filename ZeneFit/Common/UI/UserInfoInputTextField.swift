//
//  UserInfoInputTextField.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/01.
//

import UIKit
import Combine

final class UserInfoInputTextField: UIStackView {
    private var cancellable = Set<AnyCancellable>()
    
    @Published var isEnabled: Bool = true
    @Published var isFocusedInput: Bool = false
    
    private var placeHolder = ""
    
    private let titleLabel = UILabel().then {
        $0.textColor = .textAlternative
        $0.font = .pretendard(.label5)
    }
    
    let textField = UITextField().then {
        $0.textColor = .textAlternative
        $0.font = .pretendard(.label1)
    }
    
    let rightLabel = UILabel().then {
        $0.textColor = .textAlternative
        $0.font = .pretendard(.label1)
    }
    
    private let lineView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 2
        $0.backgroundColor = .textAlternative
    }
    
    private let guideLabel = UILabel().then {
        $0.isHidden = true
        $0.textColor = .primaryNormal
        $0.font = .pretendard(.caption)
    }
    
    init(title: String, placeHolder: String?, guideText: String?) {
        self.placeHolder = placeHolder ?? ""
        super.init(frame: .zero)
        titleLabel.text = title
        guideLabel.text = guideText
        configurePlaceHolder()
        
        addSubViews()
        layout()
        setUpBind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpBind() {
        $isEnabled
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnabled in
                guard let self else { return }
                isEnabled ? configureEnabledMode() : configureDisableMode()
            }
            .store(in: &cancellable)
        
        $isFocusedInput
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] isFocused in
                guard let self else { return }
                isFocused ? configureFocusedMode() : configureEnabledMode()
            }
            .store(in: &cancellable)
    }
    
    private func configureFocusedMode() {
        titleLabel.textColor = .primaryNormal
        lineView.backgroundColor = .primaryNormal
        rightLabel.textColor = .textStrong
        guideLabel.isHidden = false
        textField.textColor = .textNormal
    }
    
    private func configureEnabledMode() {
        configurePlaceHolder()
        titleLabel.textColor = .textAlternative
        lineView.backgroundColor = .textAlternative
        rightLabel.textColor = .textAlternative
        guideLabel.isHidden = true
        textField.textColor = .textAlternative
        isUserInteractionEnabled = true
    }
    
    private func configureDisableMode() {
        configurePlaceHolder()
        titleLabel.textColor = .textDisable
        lineView.backgroundColor = .lineDisable
        textField.textColor = .textDisable
        guideLabel.isHidden = true
        isUserInteractionEnabled = false
    }
    
    private func configurePlaceHolder() {
        let color: UIColor = isEnabled ? .textAlternative : .textDisable
        textField.attributedPlaceholder = .init(string: placeHolder,
                                                attributes: [.font : UIFont.pretendard(.label1),
                                                             .foregroundColor : color])
    }
    
    private func addSubViews() {
        [titleLabel, textField, lineView, guideLabel, rightLabel].forEach {
            addSubview($0)
        }
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        rightLabel.snp.makeConstraints {
            $0.leading.equalTo(textField.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(textField)
        }
        
        lineView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(textField.snp.bottom).offset(4)
            $0.height.equalTo(2)
        }
        
        guideLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(lineView.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
}
