//
//  BasicInfoInputViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/01.
//

import UIKit
import Combine

final class RegistInfoInputViewController: BaseViewController {
    weak var coordinator: AuthCoordinator?
    private let viewModel: RegistInfoInputViewModel
    
    private let titleLabel = BaseLabel().then {
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
    
    private let educationInputView = UserInfoInputTextField(title: "학력",
                                                            placeHolder: "대학 재학",
                                                            guideText: "현재 학력을 선택해주세요").then {
        $0.textField.isEnabled = false
    }
    
    private let jobInputView = UserInfoInputTextField(title: "직업",
                                                      placeHolder: "직업",
                                                      guideText: "현재 직업을 선택해주세요").then {
        $0.textField.isEnabled = false
    }
    
    private let incomeInputView = UserInfoInputTextField(title: "작년 소득",
                                                         placeHolder: "0",
                                                         guideText: "1년 기준으로 입력하세요").then {
        $0.textField.keyboardType = .numberPad
        $0.isEnabled = false
        $0.rightLabel.text = "만원"
    }
    
    private lazy var inputStackView = UIStackView(arrangedSubviews: [ageInputView, addressStackView]).then {
        $0.spacing = 8
        $0.axis = .vertical
        $0.distribution = .equalSpacing
    }
    
    private lazy var addressStackView = UIStackView(arrangedSubviews: [firstAddressInputView, secondAddressInputView]).then {
        $0.spacing = 16
        $0.distribution = .fillEqually
    }
    
    private lazy var detailInfoStackView = UIStackView(arrangedSubviews: [educationInputView, jobInputView]).then {
        $0.spacing = 16
        $0.distribution = .fillEqually
    }
    
    private let completeButton = BottomButton().then {
        $0.setTitle("완료", for: .normal)
        $0.layer.cornerRadius = 8
    }
    
    init(viewModel: RegistInfoInputViewModel) {
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
        incomBinding()
        ageBinding()
        
        viewModel.$signUpInfo
            .receive(on: RunLoop.main)
            .sink { [weak self] info in
                self?.ageInputView.textField.text = info.age
                self?.firstAddressInputView.textField.text = info.area
                self?.secondAddressInputView.textField.text = info.city
                self?.educationInputView.textField.text = info.education
                
                guard let jobs = info.job,
                      let job = jobs.first else { return }
                
                let jobContent = jobs.count > 1 ? job + " 외 \(jobs.count-1)개" : job
                self?.jobInputView.textField.text = jobContent
            }
            .store(in: &cancellable)
        
        viewModel.$focusInputNumber
            .receive(on: RunLoop.main)
            .sink { [weak self] num in
                guard let self else { return }
                ageInputView.isFocusedInput = false
                firstAddressInputView.isFocusedInput = false
                secondAddressInputView.isFocusedInput = false
                incomeInputView.isFocusedInput = false
                educationInputView.isFocusedInput = false
                jobInputView.isFocusedInput = false
                
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
                    viewModel.fetchCities()
                    firstAddressInputView.isEnabled = true
                    secondAddressInputView.isEnabled = true
                    secondAddressInputView.isFocusedInput = true
                case 4:
                    incomeInputView.textField.becomeFirstResponder()
                    incomeInputView.isFocusedInput = true
                case 5:
                    showEducationSelectionBottomSheet()
                    educationInputView.isFocusedInput = true
                case 6:
                    showJobSelectionBottomSheet()
                    jobInputView.isFocusedInput = true
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
        
        completeButton.tapPublisher
            .sink { [weak self] in
                guard let self else { return }
                switch inputStackView.arrangedSubviews.count {
                case 2:
                    view.endEditing(false)
                    UIView.animate(withDuration: 0.5) {
                        self.inputStackView.insertArrangedSubview(self.incomeInputView, at: 0)
                        self.completeButton.isEnabled = false
                        self.titleLabel.text = "소득을 알려주세요!"
                        self.view.layoutIfNeeded()
                    }
                case 3:
                    view.endEditing(false)
                    UIView.animate(withDuration: 0.5) {
                        self.inputStackView.insertArrangedSubview(self.detailInfoStackView, at: 0)
                        self.completeButton.isEnabled = false
                        self.titleLabel.text = "학력과 직업을 입력해주세요"
                        self.view.layoutIfNeeded()
                    }
                default:
                    view.endEditing(false)
                    coordinator?.setAction(.agreement)
                }
            }
            .store(in: &cancellable)
        
        viewModel.$cities
            .receive(on: RunLoop.main)
            .sink { [weak self] cities in
                self?.showCitySelectionBottomSheet(cities: cities)
            }
            .store(in: &cancellable)
    }
    
    override func setupAttributes() {
        let firstAddressTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapFirstAddress))
        firstAddressInputView.addGestureRecognizer(firstAddressTapGesture)
        let secondAddressTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSecondAddress))
        secondAddressInputView.addGestureRecognizer(secondAddressTapGesture)
        let educationTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapEducation))
        educationInputView.addGestureRecognizer(educationTapGesture)
        let jobTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapJob))
        jobInputView.addGestureRecognizer(jobTapGesture)
    }
    
    @objc func didTapFirstAddress() {
        viewModel.focusInputNumber = 2
    }
    
    @objc func didTapSecondAddress() {
        viewModel.focusInputNumber = 3
    }
    
    @objc func didTapEducation() {
        viewModel.focusInputNumber = 5
    }
    
    @objc func didTapJob() {
        viewModel.focusInputNumber = 6
    }
    
    private func showAreaSelectionBottomSheet() {
        coordinator?.showSelectionBottomSheet(title: "시/도",
                                              list: viewModel.areas,
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
    
    private func showCitySelectionBottomSheet(cities: [String]) {
        guard let area = viewModel.signUpInfo.area else { return }
        
        coordinator?.showSelectionBottomSheet(title: "시/군/구-\(area)",
                                              list: cities,
                                              selectedItem: viewModel.signUpInfo.city) { [weak self] selectedItem in
            guard let self else { return }
            if let selectedItem = selectedItem {
                viewModel.signUpInfo.city = selectedItem
            }
            
            guard selectedItem != nil || viewModel.signUpInfo.city != nil else { return }

            viewModel.cacluateFocus()
        }
    }
    
    private func showEducationSelectionBottomSheet() {
        coordinator?.showSelectionBottomSheet(title: "학력",
                                              list: ["고졸 미만","고교 재학","고졸 예정","고교 졸업","대학 재학","대졸 예정","대학 졸업","석박사"],
                                              selectedItem: viewModel.signUpInfo.education) { [weak self] selectedItem in
            guard let self else { return }
            if let selectedItem = selectedItem {
                viewModel.signUpInfo.education = selectedItem
            }
            
            guard selectedItem != nil || viewModel.signUpInfo.education != nil else { return }
            
            viewModel.cacluateFocus()
        }
    }
    
    private func showJobSelectionBottomSheet() {
        coordinator?.showMultiSelectionBottomSheet(title: "직업",
                                                   list: ["재직자","자영업자","미취업자","프리랜서","일용 근로자","(예비) 창업자","단기근로자","영농종사자"],
                                                   selectedItems: viewModel.signUpInfo.job) { [weak self] selectedItems in
            guard let self else { return }
            if let selectedItems = selectedItems {
                viewModel.signUpInfo.job = selectedItems
            }
            
            let isEmptyJob = viewModel.signUpInfo.job?.isEmpty ?? true
            guard selectedItems != nil || isEmptyJob else { return }
            
            viewModel.cacluateFocus()
        }
    }
    
    override func addSubView() {
        [titleLabel, inputStackView, completeButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func layout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        inputStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        completeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(52)
        }
    }
}

// MARK: - Income Binding
extension RegistInfoInputViewController {
    private func incomBinding() {
        incomeInputView.textField.textPublisher
            .filter { $0.isNumeric || $0.isEmpty }
            .map { $0.count > 1 ? $0.trimmingPrefix("0") : $0 }
            .sink { [weak self] text in
                
                guard let self else { return }
                incomeInputView.textField.text = String(text.prefix(6))
                
                guard text.count < 7 else { return }
                viewModel.signUpInfo.income = text
            }
            .store(in: &cancellable)
        
        incomeInputView.textField.controlPublisher(for: .editingDidBegin)
            .compactMap { [weak self] _ in self?.incomeInputView.textField.text }
            .filter { !$0.isEmpty }
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                if text.contains("억") {
                    self?.incomeInputView.textField.text = self?.viewModel.signUpInfo.income
                }
                self?.viewModel.focusInputNumber = 4
            }
            .store(in: &cancellable)
        
        incomeInputView.textField.controlPublisher(for: .editingDidEnd)
            .compactMap { [weak self] _ in self?.incomeInputView.textField.text }
            .filter { !$0.isEmpty }
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                if text.count >= 5 {
                    self?.incomeInputView.textField.text = text.formatCurreny
                }
                self?.viewModel.cacluateFocus()
            }
            .store(in: &cancellable)
    }
}

// MARK: - AgeBidning
extension RegistInfoInputViewController {
    private func ageBinding() {
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
    }
}
