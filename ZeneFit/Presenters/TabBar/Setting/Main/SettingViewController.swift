//
//  SettingViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import UIKit

final class SettingViewController: BaseViewController {
    private let viewModel: SettingViewModel
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.separatorStyle = .none
        $0.register(SettingMainCell.self, forCellReuseIdentifier: SettingMainCell.identifier)
        $0.backgroundColor = .white
    }
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        let titleLabel = UILabel().then {
            $0.text = "설정"
            $0.textColor = .textStrong
            $0.font = .pretendard(.title1)
        }
        
        navigationItem.standardAppearance?.backgroundColor = .white
        navigationItem.scrollEdgeAppearance?.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
    
    override func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func addSubView() {
        view.addSubview(tableView)
    }
    
    override func layout() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.headerItems.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = viewModel.headerItems[section]
        return SettingHeaderView(with: item)
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        " "
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: 2
        case 1: 3
        default: 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case .init(row: 0, section: 0):
            viewModel.coordinator?.setAction(.notiList)
        case .init(row: 1, section: 0):
            viewModel.coordinator?.setAction(.notiSetting)
        case .init(row: 0, section: 1):
            viewModel.coordinator?.setAction(.personalInfo)
        case .init(row: 1, section: 1):
            viewModel.coordinator?.setAction(.loginInfo)
        case .init(row: 2, section: 1):
            viewModel.coordinator?.setAction(.agreementForm)
        default:
            viewModel.coordinator?.setAction(.appInfo)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingMainCell.build(tableView)
        
        switch indexPath {
        case .init(row: 0, section: 0):
            cell.configuration(title: "알림 내역")
        case .init(row: 1, section: 0):
            cell.configuration(title: "알림 설정")
        case .init(row: 0, section: 1):
            cell.configuration(title: "개인 정보")
        case .init(row: 1, section: 1):
            cell.configuration(title: "로그인 정보")
        case .init(row: 2, section: 1):
            cell.configuration(title: "약관 및 개인 정보 처리 동의")
        default:
            cell.configuration(title: "앱 정보")
        }
        
        return cell
    }
}
