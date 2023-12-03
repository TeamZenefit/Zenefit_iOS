//
//  SettingViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import UIKit

final class SettingViewController: BaseViewController {
    private let tempLogoutButton = UIButton(type: .system).then {
        $0.setTitle("임시 로그아웃", for: .normal)
    }
    
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
            $0.font = .pretendard(.label1)
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
        view.addSubview(tempLogoutButton)
        view.addSubview(tableView)
    }
    
    override func layout() {
        tempLogoutButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupBinding() {
        tempLogoutButton.tapPublisher
            .sink { [weak self] in
                self?.viewModel.logout()
            }.store(in: &cancellable)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
        return section == 0 ? 2 : 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath {
        case .init(row: 0, section: 0):
            break
        case .init(row: 1, section: 0):
            break
        case .init(row: 0, section: 1):
            break
        case .init(row: 1, section: 1):
            break
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
