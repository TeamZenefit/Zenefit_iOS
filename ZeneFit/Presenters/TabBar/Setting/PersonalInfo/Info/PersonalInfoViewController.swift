//
//  PersonalInfoViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/4/23.
//

import UIKit
import SwiftUI

final class PersonalInfoViewController: BaseViewController {
    private let viewModel: PersonalInfoViewModel
    
    private let editButton = UIButton().then {
        $0.setImage(.init(resource: .iWr28).withRenderingMode(.alwaysOriginal),
                    for: .normal)
    }
    
    private let tableView = UITableView(frame: .zero,
                                        style: .grouped).then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.register(PersonalInfoCell.self, forCellReuseIdentifier: PersonalInfoCell.identifier)
    }
    
    init(viewModel: PersonalInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchUserInfo()
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
                guard let userInfo = self?.viewModel.userInfo.value else {
                    self?.viewModel.errorPublisher.send(CommonError.otherError)
                    return
                }
                self?.viewModel.cooridnator?.setAction(.personalInfoEdit(userInfo: userInfo))
            }.store(in: &cancellable)
        
        viewModel.userInfo
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

extension PersonalInfoViewController: UITableViewDelegate, UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonalInfoCell.identifier,
                                                 for: indexPath) as! PersonalInfoCell
        
        guard let userInfo = viewModel.userInfo.value else { return cell }
        switch indexPath.section {
        case 0:
            let type = PersonalInfoItem(rawValue: indexPath.row) ?? .age
            switch type {
            case .nickName:
                cell.configureCell(title: type.title,
                                   content: userInfo.nickname)
            case .age:
                cell.configureCell(title: type.title,
                                   content: "\(userInfo.age)")
            case .area:
                cell.configureCell(title: type.title,
                                   content: userInfo.area)
            case .city:
                cell.configureCell(title: type.title,
                                   content: userInfo.city)
            case .income:
                let income = Int(userInfo.lastYearIncome) / 10000
                cell.configureCell(title: type.title,
                                   content: "\(income) 만원")
            case .education:
                cell.configureCell(title: type.title,
                                   content: userInfo.educationType)
            case .jobs:
                cell.configureCell(title: type.title,
                                   content: userInfo.jobs.joined(separator: ", "))
            }
        default:
            let type = OtherInfoItem(rawValue: indexPath.row) ?? .gender
            switch type {
            case .gender:
                cell.configureCell(title: type.title,
                                   content: userInfo.gender)
            case .isSmallCompany:
                cell.configureCell(title: type.title,
                                   isOn: userInfo.smallBusiness)
            case .isSoldier:
                cell.configureCell(title: type.title,
                                   isOn: userInfo.soldier)
            case .isLowIncomeFamilies:
                cell.configureCell(title: type.title,
                                   isOn: userInfo.lowIncome)
            case .isDisabledPerson:
                cell.configureCell(title: type.title,
                                   isOn: userInfo.disabled)
            case .isLocalTalent:
                cell.configureCell(title: type.title,
                                   isOn: userInfo.localTalent)
            case .isFarmer:
                cell.configureCell(title: type.title,
                                   isOn: userInfo.farmer)
            }
        }
        
        return cell
    }
}
