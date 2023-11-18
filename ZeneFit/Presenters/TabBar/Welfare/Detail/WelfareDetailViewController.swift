//
//  WelfareDetailViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/12/23.
//

import UIKit

final class WelfareDetailViewController: BaseViewController {
    private let viewModel: WelfareDetailViewModel
    
    private let titleLabel = UILabel().then {
        $0.text = "정책 이름을 신청하면\n월 n만원 정도를 받을 수 있어요"
        $0.textColor = .textStrong
        $0.font = .pretendard(.label1)
        $0.numberOfLines = 2
    }
    
    private let subTitleLabel = UILabel().then {
        $0.textColor = .textAlternative
        $0.font = .pretendard(.body1)
        $0.isHidden = true
    }
    
    private let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.register(WelfareDetailCell.self, forCellReuseIdentifier: WelfareDetailCell.identifier)
    }
    
    private let applyButton = BottomButton().then {
        $0.setTitle("지금 신청하기", for: .normal)
        $0.layer.cornerRadius = 8
        $0.titleLabel?.font = .pretendard(.label3)
    }
    
    private let interestButton = UIButton().then {
        $0.setTitle("관심 정책 등록하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .pretendard(.label3)
        $0.backgroundColor = .primaryNormal
        $0.layer.cornerRadius = 8
        $0.isHidden = true
    }
    
    private let detailFetchButton = UIButton().then {
        $0.setTitle("상세 조회", for: .normal)
        $0.setTitleColor(.primaryNormal, for: .normal)
        $0.titleLabel?.font = .pretendard(.label3)
        $0.backgroundColor = .primaryAssistive
        $0.layer.cornerRadius = 8
        $0.isHidden = true
    }
    
    init(viewModel: WelfareDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubView() {
        [titleLabel, subTitleLabel, tableView, applyButton, detailFetchButton, interestButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func layout() {
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(56)
        }
        
        applyButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            $0.height.equalTo(48)
        }
        
        detailFetchButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(view.snp.centerX).offset(-4)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            $0.height.equalTo(48)
        }
        
        interestButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(view.snp.centerX).offset(4)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            $0.height.equalTo(48)
        }
    }
    
    override func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension WelfareDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WelfareDetailCell.identifier, for: indexPath) as! WelfareDetailCell
        
        switch indexPath.row {
        case 0:
            cell.configureCell(title: "서비스 소개", content: "유치원에 다니는 만 3~5세 아동에게 유아학비, 방과후 과정비 등 지원")
        case 1:
            cell.configureCell(title: "신청 서류", content: "주민등록등본, 신분증, 확정일 자부 월세 계약서 사본, 계약금 지급 영수증")
        case 2:
            cell.configureCell(title: "신청 방법", content: "홈페이지에 접속해서 별도 회원가입한 후 수강신청")
        default:
            cell.configureApplyTypeCell(title: "신청 기간", content: nil, types: ["상시신청"])
            
        }
        return cell
    }
}
