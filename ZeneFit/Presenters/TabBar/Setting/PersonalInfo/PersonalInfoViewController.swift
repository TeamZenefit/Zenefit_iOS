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
        $0.setImage(.init(resource: .iWr28Del).withRenderingMode(.alwaysOriginal),
                    for: .selected)
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
            .sink { [weak self] in
                self?.editButton.isSelected.toggle()
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
        switch indexPath.section {
        case 0:
            let item = viewModel.personalInfoItems[indexPath.row]
            cell.configureCell(title: item.rawValue,
                               content: "임시 내용")
        default:
            let item = viewModel.otherInfoItems[indexPath.row]
            cell.configureCell(title: item.rawValue,
                               content: "임시 내용")
        }
        
        return cell
    }
}

#Preview(body: {
    let vc = PersonalInfoViewController(viewModel: PersonalInfoViewModel(cooridnator: nil))
    return UINavigationController(rootViewController: vc).preview
})
