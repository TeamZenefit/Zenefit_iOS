//
//  InfoEditTextField.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/7/24.
//

import UIKit
import Combine

final class InfoEditTextField: BaseView {
    private var cancellable = Set<AnyCancellable>()
    
    let textField = UITextField().then {
        $0.textColor = .textAlternative
        $0.font = .pretendard(.label1)
        $0.textAlignment = .right
    }
    
    private let lineView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 2
        $0.backgroundColor = .textAlternative
    }
    
    override func setupBinding() {
        self.textField.controlPublisher(for: .editingDidEnd)
            .receive(on: RunLoop.main)
            .sink { [weak self] isFocused in
                guard let self else { return }
                self.configureEnabledMode()
            }
            .store(in: &cancellable)
        
        self.textField.controlPublisher(for: .editingDidBegin)
            .receive(on: RunLoop.main)
            .sink { [weak self] isFocused in
                guard let self else { return }
                self.configureFocusedMode()
            }
            .store(in: &cancellable)
    }
    
    private func configureFocusedMode() {
        lineView.backgroundColor = .primaryNormal
        textField.textColor = .textNormal
    }
    
    private func configureEnabledMode() {
        lineView.backgroundColor = .textAlternative
        textField.textColor = .textAlternative
    }
    
    override func addSubView() {
        [textField, lineView].forEach {
            addSubview($0)
        }
    }
    
    override func setDelegate() {
        textField.delegate = self
    }
    
    override func setLayout() {
        textField.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().offset(4)
        }
        
        lineView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(textField.snp.bottom).offset(4)
            $0.height.equalTo(2)
        }
    }
}

extension InfoEditTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(false)
        return true
    }
}
