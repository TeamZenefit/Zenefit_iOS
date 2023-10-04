//
//  BasicInfoInputViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/01.
//

import UIKit
import Combine

final class BasicInfoInputViewController: BaseViewController {
    private var cancellable = Set<AnyCancellable>()
    weak var coordinator: AuthCoordinator?
    private let viewModel: BasicInfoViewModel
    
    private let basicInfoLabel = SignUpOrderLabel(number: 1, title: "기본 정보")
    
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(.label1)
        $0.textColor = .textStrong
        $0.text = "나이와 사는 곳을 알려주세요!"
    }
    
    private let ageInputView = UserInfoInputTextField(title: "나이",
                                                      placeHolder: "나이",
                                                      guideText: "만 나이를 입력하세요").then {
        $0.textField.keyboardType = .numberPad
    }
    
    private let firstAddressInputView = UserInfoInputTextField(title: "시/도",
                                                               placeHolder: "시/도",
                                                               guideText: "등본상 거주지를 입력하세요").then {
        $0.textField.isEnabled = false
    }
    
    private let secondAddressInputView = UserInfoInputTextField(title: "시/군/구",
                                                                placeHolder: "시/군/구",
                                                                guideText: "등본상 거주지를 입력하세요").then {
        $0.textField.isEnabled = false
    }
    
    private let completeButton = BottomButton().then {
        $0.setTitle("완료", for: .normal)
        $0.layer.cornerRadius = 8
    }
    
    init(viewModel: BasicInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        responseToKeyboardHegiht(completeButton)
    }
    
    override func setupBinding() {
        ageInputView.textField.controlPublisher(for: .editingDidBegin)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.viewModel.focusInputNumber = 1
            }
            .store(in: &cancellable)
        
        ageInputView.textField.controlPublisher(for: .editingDidEnd)
            .compactMap { [weak self] _ in self?.ageInputView.textField.text }
            .filter { !$0.isEmpty }
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.viewModel.cacluateFocus()
            }
            .store(in: &cancellable)
        
        ageInputView.textField.textPublisher
            .map { $0.filter { $0.isNumber } }
            .map { $0.prefix(1) == "0" ? "" : $0 }
            .map { String($0.prefix(2)) }
            .sink { [weak self] text in
                guard let self else { return }
                
                ageInputView.textField.text = text
                viewModel.signUpInfo.age = text
                
                if text.count >= 2 {
                    view.endEditing(false)
                }
            }
            .store(in: &cancellable)
        
        completeButton.tapPublisher
            .sink { [weak self] in
                self?.view.endEditing(false)
                self?.coordinator?.pushToIncomeInputVC()
            }
            .store(in: &cancellable)
        
        viewModel.$signUpInfo
            .receive(on: RunLoop.main)
            .sink { [weak self] info in
                self?.firstAddressInputView.textField.text = info.area
                self?.secondAddressInputView.textField.text = info.city
            }
            .store(in: &cancellable)
        
        viewModel.$focusInputNumber
            .receive(on: RunLoop.main)
            .sink { [weak self] num in
                guard let self else { return }
                ageInputView.isFocusedInput = false
                firstAddressInputView.isFocusedInput = false
                secondAddressInputView.isFocusedInput = false
                
                switch num {
                case 1:
                    ageInputView.textField.becomeFirstResponder()
                    ageInputView.isFocusedInput = true
                    firstAddressInputView.isEnabled = false
                    secondAddressInputView.isEnabled = false
                case 2:
                    showAreaSelectionBottomSheet()
                    firstAddressInputView.isEnabled = true
                    secondAddressInputView.isEnabled = false
                    firstAddressInputView.isFocusedInput = true
                case 3:
                    showCitySelectionBottomSheet()
                    firstAddressInputView.isEnabled = true
                    secondAddressInputView.isEnabled = true
                    secondAddressInputView.isFocusedInput = true
                default:
                    firstAddressInputView.isEnabled = true
                    secondAddressInputView.isEnabled = true
                }
            }
            .store(in: &cancellable)
        
        viewModel.$completionEnable
            .receive(on: RunLoop.main)
            .assign(to: \.completeButton.isEnabled, on: self)
            .store(in: &cancellable)
    }
    
    override func setupAttributes() {
        let firstAddressTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapFirstAddress))
        firstAddressInputView.addGestureRecognizer(firstAddressTapGesture)
        let secondAddressTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSecondAddress))
        secondAddressInputView.addGestureRecognizer(secondAddressTapGesture)
    }
    
    @objc func didTapFirstAddress() {
        viewModel.focusInputNumber = 2
    }
    
    @objc func didTapSecondAddress() {
        viewModel.focusInputNumber = 3
    }
    
    private func showAreaSelectionBottomSheet() {
        coordinator?.showSelectionBottomSheet(title: "시/도",
                                              list: ["비밀","입니당~"],
                                              selectedItem: viewModel.signUpInfo.area) { [weak self] selectedItem in
            guard let self else { return }
            if let selectedItem = selectedItem {
                viewModel.signUpInfo.area = selectedItem
                viewModel.signUpInfo.city = nil
            }

            guard selectedItem != nil || viewModel.signUpInfo.area != nil else { return }

            viewModel.cacluateFocus()
        }
    }
    
    private func showCitySelectionBottomSheet() {
        guard let area = viewModel.signUpInfo.area else { return }
        
        coordinator?.showSelectionBottomSheet(title: "시/군/구-\(area)",
                                              list: ["이래요","비밀","비밀","비밀","비밀","비밀"],
                                              selectedItem: viewModel.signUpInfo.city) { [weak self] selectedItem in
            guard let self else { return }
            if let selectedItem = selectedItem {
                viewModel.signUpInfo.city = selectedItem
            }
            
            guard selectedItem != nil || viewModel.signUpInfo.city != nil else { return }

            viewModel.cacluateFocus()
        }
    }
    
    override func addSubView() {
        [basicInfoLabel, titleLabel, ageInputView, firstAddressInputView, secondAddressInputView, completeButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func layout() {
        basicInfoLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(basicInfoLabel.snp.bottom).offset(16)
        }
        
        ageInputView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        firstAddressInputView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(view.snp.centerX).offset(-8)
            $0.top.equalTo(ageInputView.snp.bottom).offset(16)
        }
        
        secondAddressInputView.snp.makeConstraints {
            $0.top.equalTo(ageInputView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.leading.equalTo(view.snp.centerX).offset(8)
        }
        
        completeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(52)
        }
    }
}
