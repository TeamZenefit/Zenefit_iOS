//
//  WelfareViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import UIKit

final class WelfareViewController: BaseViewController {
    
    private let viewModel: WelfareViewModel
    
    private let notiButton = UIButton(type: .system).then {
        $0.setImage(.init(named: "alarm_off")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private let tableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.register(WelfareMainItemCell.self, forCellReuseIdentifier: WelfareMainItemCell.identifier)
        $0.backgroundColor = .backgroundPrimary
    }
    
    init(viewModel: WelfareViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getWelfareMainInfo()
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        self.navigationController?.navigationBar.isHidden = false
        let titleLabel = UILabel().then {
            $0.text = "정책"
            $0.textColor = .textStrong
            $0.font = .pretendard(.label1)
        }
        
        navigationItem.standardAppearance?.backgroundColor = .backgroundPrimary
        navigationItem.scrollEdgeAppearance?.backgroundColor = .backgroundPrimary
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = .init(customView: notiButton)
    }
    
    override func configureUI() {
        view.backgroundColor = .backgroundPrimary
    }
    
    override func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func setupBinding() {
        viewModel.policyItems
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
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

extension WelfareViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.policyItems.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WelfareMainItemCell.identifier, for: indexPath) as! WelfareMainItemCell
        let targetItem = viewModel.policyItems.value[indexPath.row]
        cell.configureCell(item: targetItem)
        
        cell.titleTapHandler = { [weak self] in
            self?.viewModel.coordinator?.setAction(.list(type: .init(rawValue: targetItem.supportType) ?? .money))
        }
        
        cell.applyTapHandler = { [weak self] in
            self?.viewModel.coordinator?.setAction(.detail(id: targetItem.policyID))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}
