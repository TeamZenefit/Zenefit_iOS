//
//  PersonalInfoEditCell.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/7/24.
//

import UIKit
import Combine

final class PersonalInfoEditCell: UITableViewCell {
    private var cancellable = Set<AnyCancellable>()
    
    var switchHandler: ((Bool)->Void)?
    var editTextHandler: ((String)->Void)?
    var selectedHandler: ((String)->Void)?
    
    private let titleLabel = BaseLabel().then {
        $0.font = .pretendard(.body1)
        $0.textColor = .textNormal
    }
    
    let contentTextField = InfoEditTextField().then {
        $0.textField.font = .pretendard(.label3)
    }
    
    private let switchView = UISwitch().then {
        $0.isHidden = true
        $0.onTintColor = .primaryNormal
    }
    
    private lazy var genderView = GenderSelectionView().then {
        $0.changedGender = { [weak self] gender in
            self?.selectedHandler?(gender.rawValue)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        setLayout()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(title: String, content: String? = nil, isOn: Bool? = nil, gender: GenderType? = nil) {
        titleLabel.text = title
        contentTextField.textField.text = content
        if let isOn {
            contentTextField.isHidden = true
            switchView.isHidden = false
            switchView.isOn = isOn
        }
        
        if let gender {
            contentTextField.isHidden = true
            genderView.isHidden = false
            genderView.gender = gender
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentTextField.isHidden = false
        switchView.isHidden = true
        genderView.isHidden = true
        switchHandler = nil
        selectedHandler = nil
        editTextHandler = nil
        contentTextField.textField.keyboardType = .default
        contentTextField.textField.isEnabled = true
    }
    
    private func setupBinding() {
        switchView.controlPublisher(for: .valueChanged)
            .sink { [weak self] _ in
                guard let self else { return }
                
                switchHandler?(self.switchView.isOn)
            }.store(in: &cancellable)
        
        contentTextField.textField.controlPublisher(for: .editingDidEnd)
            .sink { [weak self] _ in
                guard let self,
                      let text = contentTextField.textField.text else { return }
                editTextHandler?(text)
            }.store(in: &cancellable)
        
        contentTextField.textField.controlPublisher(for: .editingDidBegin)
            .sink { [weak self] _ in
                guard let self,
                      let text = contentTextField.textField.text else { return }
                if text.contains(" 만원") {
                    contentTextField.textField.text = text.replacingOccurrences(of: " 만원", with: "")
                }
            }.store(in: &cancellable)
    }
    
    private func setLayout() {
        [titleLabel, contentTextField, switchView, genderView].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(16)
        }
        
        contentTextField.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().offset(-16)
            $0.leading.equalTo(self.contentView.snp.centerX).offset(-20)
        }
        
        switchView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        genderView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(32)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}
