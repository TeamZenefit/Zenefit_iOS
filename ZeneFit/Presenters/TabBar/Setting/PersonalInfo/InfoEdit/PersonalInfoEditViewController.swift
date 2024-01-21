//
//  PersonalInfoEditViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/7/24.
//

import UIKit

final class PersonalInfoEditViewController: BaseViewController {
    private let viewModel: PersonalInfoEditViewModel
    
    private let editButton = UIButton().then {
        $0.setImage(.init(resource: .iWr28Edit).withRenderingMode(.alwaysOriginal),
                    for: .normal)
    }
    
    private let tableView = UITableView(frame: .zero,
                                        style: .grouped).then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.register(PersonalInfoEditCell.self, forCellReuseIdentifier: PersonalInfoEditCell.identifier)
    }
    
    init(viewModel: PersonalInfoEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        hidesBottomBarWhenPushed = true
        navigationItem.backBarButtonItem = .init(title: "뒤",
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(didClickBackButton))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        setTitle = "개인 정보"
        
        navigationItem.rightBarButtonItem = .init(customView: editButton)
    }
    
    @objc override func didClickBackButton() {
        let alert = StandardAlertController(title: "개인정보 수정을 취소할까요??", message: "네를 누르면\n수정 전의 내용으로 저장됩니다.")
        let cancel = StandardAlertAction(title: "아니오", style: .cancel)
        let back = StandardAlertAction(title: "  네  ", style: .blue, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(cancel, back)
        self.present(alert, animated: false)
    }
    
    override func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func setupBinding() {
        editButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.view.endEditing(false)
                self?.viewModel.updateUserInfo()
            }.store(in: &cancellable)
        
        viewModel.newUserInfo
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }.store(in: &cancellable)
        
        viewModel.updateSuccess
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &cancellable)
        
        viewModel.errorPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                switch error {
                case CommonError.invalidAge:
                    self?.notiAlert("유효하지않은 나이입니다. 다시 입력해주세요.")
                case CommonError.invalidIncome:
                    self?.notiAlert("유효하지않은 수입입니다. 다시 입력해주세요.")
                default:
                    self?.notiAlert("알 수 없는에러가 발생했습니다.")
                }
            }.store(in: &cancellable)
    }
    
    override func addSubView() {
        [tableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func layout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension PersonalInfoEditViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = PaddingLabel(padding: .init(top: 20, left: 16, bottom: 8, right: 0))
        label.font = .pretendard(.label2)
        label.textColor = .textStrong
        label.text = section == 0 ? "개인 정보" : "기타 정보"
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let dividerView = UIView(frame: .init(origin: .zero,
                                              size: .init(width: view.frame.width,
                                                          height: 12)))
        dividerView.backgroundColor = .backgroundPrimary
        
        return section == 0 ? dividerView : nil
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ?
        viewModel.personalInfoItems.count :
        viewModel.otherInfoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonalInfoEditCell.identifier,
                                                 for: indexPath) as! PersonalInfoEditCell
        guard let userInfo = viewModel.newUserInfo.value else { return cell }
        
        switch indexPath.section {
        case 0:
            let type = PersonalInfoItem(rawValue: indexPath.row) ?? .age
            switch type {
            case .nickName:
                cell.configureCell(title: type.title,
                                   content: userInfo.nickname)
                cell.editTextHandler = { [weak self] text in
                    self?.viewModel.newUserInfo.value?.nickname = text
                }
            case .age:
                cell.configureCell(title: type.title,
                                   content: "\(userInfo.age)")
                cell.contentTextField.textField.keyboardType = .numberPad
                cell.editTextHandler = { [weak self] text in
                    self?.viewModel.newUserInfo.value?.age = Int(text) ?? 0
                }
            case .area:
                cell.configureCell(title: type.title,
                                   content: userInfo.area)
                cell.contentTextField.textField.isEnabled = false
            case .city:
                cell.configureCell(title: type.title,
                                   content: userInfo.city)
                cell.contentTextField.textField.isEnabled = false
            case .income:
                let income = Int(userInfo.lastYearIncome) / 10000
                cell.configureCell(title: type.title,
                                   content: "\(income) 만원")
                cell.contentTextField.textField.keyboardType = .numberPad
                cell.editTextHandler = { [weak self] text in
                    guard let self,
                          let income = Double(text.appending("0000")) else { return }
                    viewModel.newUserInfo.value?.lastYearIncome = income
                }
            case .education:
                cell.configureCell(title: type.title,
                                   content: userInfo.educationType)
                cell.contentTextField.textField.isEnabled = false
            case .jobs:
                cell.configureCell(title: type.title,
                                   content: userInfo.jobs.joined(separator: ", "))
                cell.contentTextField.textField.isEnabled = false
            }
        default:
            let type = OtherInfoItem(rawValue: indexPath.row) ?? .gender
            switch type {
            case .gender:
                cell.configureCell(title: type.title,
                                   gender: GenderType(rawValue: userInfo.gender) ?? .male)
                cell.selectedHandler = { [weak self] gender in
                    self?.viewModel.newUserInfo.value?.gender = gender
                }
            case .isSmallCompany:
                cell.configureCell(title: type.title,
                                   isOn: userInfo.smallBusiness)
                cell.switchHandler = { [weak self] isOn in
                    self?.viewModel.newUserInfo.value?.smallBusiness = isOn
                }
            case .isSoldier:
                cell.configureCell(title: type.title,
                                   isOn: userInfo.soldier)
                cell.switchHandler = { [weak self] isOn in
                    self?.viewModel.newUserInfo.value?.soldier = isOn
                }
            case .isLowIncomeFamilies:
                cell.configureCell(title: type.title,
                                   isOn: userInfo.lowIncome)
                cell.switchHandler = { [weak self] isOn in
                    self?.viewModel.newUserInfo.value?.lowIncome = isOn
                }
            case .isDisabledPerson:
                cell.configureCell(title: type.title,
                                   isOn: userInfo.disabled)
                cell.switchHandler = { [weak self] isOn in
                    self?.viewModel.newUserInfo.value?.disabled = isOn
                }
            case .isLocalTalent:
                cell.configureCell(title: type.title,
                                   isOn: userInfo.localTalent)
                cell.switchHandler = { [weak self] isOn in
                    self?.viewModel.newUserInfo.value?.localTalent = isOn
                }
            case .isFarmer:
                cell.configureCell(title: type.title,
                                   isOn: userInfo.farmer)
                cell.switchHandler = { [weak self] isOn in
                    self?.viewModel.newUserInfo.value?.farmer = isOn
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(false)
        if indexPath.section == 0 {
            let type = PersonalInfoItem(rawValue: indexPath.row) ?? .age
            switch type {
            case .area:
                viewModel.coordinator?.showSelectionBottomSheet(title: "지역",
                                                                list: viewModel.areas,
                                                                selectedItem: viewModel.newUserInfo.value?.area,
                                                                completion: { [weak self] newArea in
                    guard let newArea else { return }
                    self?.viewModel.newUserInfo.value?.area = newArea
                })
            case .city:
                guard let area = viewModel.newUserInfo.value?.area else { return }
                viewModel.coordinator?.showSelectionBottomSheet(title: "소속지역 - \(area)",
                                                                list: viewModel.cities,
                                                                selectedItem: viewModel.newUserInfo.value?.city,
                                                                completion: { [weak self] newCity in
                    guard let newCity else { return }
                    self?.viewModel.newUserInfo.value?.city = newCity
                })
            case .education:
                viewModel.coordinator?.showSelectionBottomSheet(title: "학력",
                                                                list: ["고졸 미만","고교 재학","고졸 예정","고교 졸업","대학 재학","대졸 예정","대학 졸업","석박사"],
                                                                selectedItem: viewModel.newUserInfo.value?.educationType) { [weak self] education in
                    guard let education else { return }
                    self?.viewModel.newUserInfo.value?.educationType = education
                }
            case .jobs:
                viewModel.coordinator?.showMultiSelectionBottomSheet(title: "직업",
                                                                     list: ["재직자","자영업자","미취업자","프리랜서","일용 근로자","(예비) 창업자","단기근로자","영농종사자"],
                                                                     selectedItems: viewModel.newUserInfo.value?.jobs) { [weak self] newJobs in
                    
                    guard let newJobs else { return }
                    self?.viewModel.newUserInfo.value?.jobs = newJobs
                }
            default:
                    break
            }
        }
    }
}
