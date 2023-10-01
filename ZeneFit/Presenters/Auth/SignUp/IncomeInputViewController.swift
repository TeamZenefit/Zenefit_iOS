//
//  IncomeInputViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/01.
//

import UIKit
import Combine

final class IncomeInputViewController: BaseViewController {
    private var cancellable = Set<AnyCancellable>()
    weak var coordinator: AuthCoordinator?
    private let viewModel: SignUpViewModel
    
    private let basicInfoLabel = SignUpOrderLabel(number: 2, title: "소득 정보")
    
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(.label1)
        $0.textColor = .textStrong
        $0.text = "소득을 알려주세요!"
    }
    
    private let incomeInputView = UserInfoInputTextField(title: "작년 소득",
                                                      placeHolder: "0",
                                                      guideText: "1년 기준으로 입력하세요").then {
        $0.textField.keyboardType = .numberPad
        $0.rightLabel.text = "만원"
    }
    
    private let ageInputView = UserInfoInputTextField(title: "나이",
                                                      placeHolder: "나이",
                                                      guideText: "만 나이를 입력하세요").then {
        $0.isEnabled = false
    }
    
    private let firstAddressInputView = UserInfoInputTextField(title: "시/도",
                                                               placeHolder: "시/도",
                                                               guideText: "등본상 거주지를 입력하세요").then {
        $0.isEnabled = false
    }
    
    private let secondAddressInputView = UserInfoInputTextField(title: "시/군/구",
                                                                placeHolder: "시/군/구",
                                                                guideText: "등본상 거주지를 입력하세요").then {
        $0.isEnabled = false
    }
    
    private let completeButton = BottomButton().then {
        $0.setTitle("완료", for: .normal)
        $0.layer.cornerRadius = 8
//        $0.isEnabled = false
    }
    
    init(viewModel: SignUpViewModel) {
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
        incomeInputView.textField.controlPublisher(for: .editingChanged)
            .sink { [weak self] _ in
                guard let self,
                      let text = self.incomeInputView.textField.text,
                      let income = Int(text) else { return }
                viewModel.signUpInfo.income = income
            }
            .store(in: &cancellable)
        
        completeButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.coordinator?.pushToDetailInfoInputVC()
            }
            .store(in: &cancellable)
        
        viewModel.$signUpInfo
            .receive(on: RunLoop.main)
            .sink { [weak self] info in
                self?.ageInputView.textField.text = String(info.age ?? 0)
                self?.firstAddressInputView.textField.text = info.area
                self?.secondAddressInputView.textField.text = info.city
            }
            .store(in: &cancellable)
    }
    
    override func addSubView() {
        [basicInfoLabel, titleLabel, incomeInputView, ageInputView, firstAddressInputView, secondAddressInputView, completeButton].forEach {
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
        
        incomeInputView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        ageInputView.snp.makeConstraints {
            $0.top.equalTo(incomeInputView.snp.bottom).offset(16)
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
