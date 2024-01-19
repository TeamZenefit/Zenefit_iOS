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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        setTitle = "개인 정보"
        
        navigationItem.rightBarButtonItem = .init(customView: editButton)
    }
    
    override func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func setupBinding() {
        editButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.editButton.isSelected.toggle()
                self?.tableView.reloadData()
            }.store(in: &cancellable)
        
        viewModel.newUserInfo
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
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
            let item = viewModel.personalInfoItems[indexPath.row]
            switch indexPath.row {
            case 0:
                cell.configureCell(title: item.title,
                                   content: userInfo.nickname)
            case 1:
                cell.configureCell(title: item.title,
                                   content: "\(userInfo.age)")
            case 2:
                cell.configureCell(title: item.title,
                                   content: userInfo.area + " " + userInfo.city)
            case 3:
                let income = Int(userInfo.lastYearIncome) / 10000
                cell.configureCell(title: item.title,
                                   content: "\(income) 만원")
            case 4:
                cell.configureCell(title: item.title,
                                   content: userInfo.educationType)
            default:
                cell.configureCell(title: item.title,
                                   content: userInfo.jobs.joined(separator: ", "))
            }
        default:
            let item = viewModel.otherInfoItems[indexPath.row]
            switch indexPath.row {
            case 0:
                cell.configureCell(title: item.title,
                                   content: userInfo.gender)
                break
            case 1:
                cell.configureCell(title: item.title,
                                   isOn: userInfo.smallBusiness)
            case 2:
                cell.configureCell(title: item.title,
                                   isOn: userInfo.soldier)
            case 3:
                cell.configureCell(title: item.title,
                                   isOn: userInfo.lowIncome)
            case 4:
                cell.configureCell(title: item.title,
                                   isOn: userInfo.disabled)
            case 5:
                cell.configureCell(title: item.title,
                                   isOn: userInfo.localTalent)
            default:
                cell.configureCell(title: item.title,
                                   isOn: userInfo.farmer)
            }
        }
        
        return cell
    }
}
