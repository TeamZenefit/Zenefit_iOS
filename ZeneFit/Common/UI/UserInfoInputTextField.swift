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
    
    private var placeHolderAttribute: [NSAttributedString.Key: Any] {
        [.font : UIFont.pretendard(.label1),
         .foregroundColor : UIColor.textAlternative]
    }
    
    init(title: String, placeHolder: String?, guideText: String?) {
        super.init(frame: .zero)
        titleLabel.text = title
        guideLabel.text = guideText
        textField.attributedPlaceholder = .init(string: placeHolder ?? "",
                                                attributes: placeHolderAttribute)
        
        addSubViews()
        layout()
        setUpBind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpBind() {
        textField.controlPublisher(for: .editingDidBegin)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.titleLabel.textColor = .primaryNormal
                self?.lineView.backgroundColor = .primaryNormal
                self?.rightLabel.textColor = .textStrong
                self?.guideLabel.isHidden = false
                self?.textField.textColor = .textNormal
            }.store(in: &cancellable)
        
        textField.controlPublisher(for: .editingDidEnd)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.titleLabel.textColor = .textAlternative
                self?.lineView.backgroundColor = .textAlternative
                self?.rightLabel.textColor = .textAlternative
                self?.guideLabel.isHidden = true
                self?.textField.textColor = .textAlternative
            }.store(in: &cancellable)
        
        $isEnabled
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnabled in
                guard !isEnabled else { return }
                self?.titleLabel.textColor = .textDisable
                self?.lineView.backgroundColor = .lineDisable
                self?.textField.textColor = .textDisable
                self?.textField.isEnabled = false
            }
            .store(in: &cancellable)
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
            $0.bottom.equalToSuperview()
        }
    }
}
