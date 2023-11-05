//
//  BenefitViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/02.
//

import UIKit

final class BenefitViewController: BaseViewController {
    private let viewModel: BenefitViewModel
    
    private let topFrameView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "수혜중인 정책"
        $0.font = .pretendard(.body2)
        $0.textColor = .textNormal
    }
    
    private let bookmarkCountLabel = UILabel().then {
        $0.text = "n개"
        $0.font = .pretendard(.body2)
        $0.textColor = .textNormal
    }
    
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(BenefitCell.self, forCellReuseIdentifier: BenefitCell.identifier)
        $0.backgroundColor = .backgroundPrimary
    }
    
    init(viewModel: BenefitViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        view.backgroundColor = .backgroundPrimary
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        setTitle = "수혜 정책"
    }
    
    override func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func addSubView() {
        [topFrameView, tableView].forEach {
            view.addSubview($0)
        }
           
        [subTitleLabel, bookmarkCountLabel].forEach {
            topFrameView.addSubview($0)
        }
    }
    
    override func layout() {
        topFrameView.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(48)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(16)
        }
        
        bookmarkCountLabel.snp.makeConstraints {
            $0.trailing.top.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(topFrameView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

extension BenefitViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.policyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BenefitCell.identifier, for: indexPath) as! BenefitCell
        
        return cell
    }
}

