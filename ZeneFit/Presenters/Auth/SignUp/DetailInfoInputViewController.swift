//
//  DetailInfoInputViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/01.
//

import UIKit
import Combine

final class DetailInfoInputViewController: BaseViewController {
    private var cancellable = Set<AnyCancellable>()
    weak var coordinator: AuthCoordinator?
    private let viewModel: SignUpViewModel
    
    private let basicInfoLabel = SignUpOrderLabel(number: 3, title: "상세 정보")
    
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(.label1)
        $0.textColor = .textStrong
        $0.text = "학력과 직업을 입력해주세요!"
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
        $0.isEnabled = false
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
        viewModel.$signUpInfo
            .receive(on: RunLoop.main)
            .sink { [weak self] info in
                self?.incomeInputView.textField.text = String(info.income ?? 0)
                self?.ageInputView.textField.text = String(info.age ?? 0)
                self?.firstAddressInputView.textField.text = info.area
                self?.secondAddressInputView.textField.text = info.city
                self?.educationInputView.textField.text = info.education
                
                guard let jobs = info.job,
                      let job = jobs.first else { return }
                
                let jobContent = jobs.count > 1 ? job + "외 \(jobs.count-1)개" : job
                self?.jobInputView.textField.text = jobContent
            }
            .store(in: &cancellable)
    }
    
    override func setupAttributes() {
        let educationTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapEducation))
        educationInputView.addGestureRecognizer(educationTapGesture)
        let jobTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapJob))
        jobInputView.addGestureRecognizer(jobTapGesture)
    }
    
    @objc func didTapEducation() {
        coordinator?.showSelectionBottomSheet(title: "학력 선택",
                                              list: ["고졸 미만","고교 재학","고졸 예정","고교 졸업","대학 재학","대졸 예정","대학 졸업","석박사"],
                                              selectedItem: viewModel.signUpInfo.education) { [weak self] selectedItem in
            self?.viewModel.signUpInfo.education = selectedItem
        }
    }
    
    @objc func didTapJob() {
        coordinator?.showMultiSelectionBottomSheet(title: "직업 선택",
                                                   list: ["재직자","자영업자","미취업자","프리랜서","일용 근로자","(예비) 창업자","단기근로자","영농종사자"],
                                                   selectedItems: viewModel.signUpInfo.job) { [weak self] selectedItemms in
            self?.viewModel.signUpInfo.job = selectedItemms
        }
    }
    
    override func addSubView() {
        [basicInfoLabel, titleLabel, educationInputView, jobInputView, incomeInputView, ageInputView, firstAddressInputView, secondAddressInputView, completeButton].forEach {
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
        
        educationInputView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(view.snp.centerX).offset(-8)
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
        }
        
        jobInputView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.trailing.equalToSuperview().offset(-16)
            $0.leading.equalTo(view.snp.centerX).offset(8)
        }
        
        incomeInputView.snp.makeConstraints {
            $0.top.equalTo(educationInputView.snp.bottom).offset(16)
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
