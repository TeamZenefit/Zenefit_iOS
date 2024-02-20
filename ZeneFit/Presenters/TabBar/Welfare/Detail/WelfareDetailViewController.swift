//
//  WelfareDetailViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/12/23.
//

import UIKit
import SafariServices

final class WelfareDetailViewController: BaseViewController {
    private let viewModel: WelfareDetailViewModel
    
    private lazy var errorView = DefaultErrorView().then {
        $0.retryHandler = { [weak self] in
            self?.viewModel.getPolicyDetailInfo()
        }
        $0.isHidden = true
    }
    private let titleView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let titleLabel = BaseLabel().then {
        $0.textColor = .textStrong
        $0.font = .pretendard(.label1)
        $0.numberOfLines = 0
    }
    
    private let subTitleLabel = BaseLabel().then {
        $0.textColor = .textAlternative
        $0.font = .pretendard(.body1)
        $0.isHidden = true
    }
    
    private let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.bounces = false
        $0.register(WelfareDetailCell.self, forCellReuseIdentifier: WelfareDetailCell.identifier)
        $0.register(WelfareDetailDateTypeCell.self, forCellReuseIdentifier: WelfareDetailDateTypeCell.identifier)
    }
    
    private let applyButton = BottomButton().then {
        $0.setTitle("지금 신청하기", for: .normal)
        $0.layer.cornerRadius = 8
        $0.titleLabel?.font = .pretendard(.label3)
        $0.isHidden = true
    }
    
    private let interestButton = UIButton().then {
        $0.setTitle("관심 정책 등록하기", for: .normal)
        $0.setTitle("관심 정책 등록완료", for: .selected)
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
    
    override func setupBinding() {
        viewModel.detailInfo
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] info in
                let hasLastConsonat = info.policyName.hasLastConsonant
                let preposition1 = hasLastConsonat ? "을" : "를"
                let preposition2 = hasLastConsonat ? "은" : "는"
                
                if let reason = info.policyApplyDenialReason {
                    self?.titleLabel.text = "\(info.policyName)\(preposition2) 신청할 수 없어요"
                    self?.subTitleLabel.text = reason
                    self?.subTitleLabel.isHidden = false
                    self?.interestButton.isHidden = false
                    self?.detailFetchButton.isHidden = false
                    self?.applyButton.isHidden = true
                    self?.interestButton.isSelected = info.interestFlag
                    self?.interestButton.backgroundColor = info.interestFlag ? .fillDisable : .primaryNormal
                } else {
                    self?.interestButton.isHidden = true
                    self?.subTitleLabel.isHidden = true
                    self?.applyButton.isHidden = false
                    self?.detailFetchButton.isHidden = true
                    
                    if let benefit = info.benefit {
                        let title = "\(info.policyName)\(preposition1) 신청하면 월 \(benefit/10000)만원 정도를 받을 수 있어요"
                        self?.titleLabel.text = title
                        self?.titleLabel.setPointTextAttribute("월 \(benefit/10000)만원", color: .primaryNormal)
                    } else {
                        let title = "\(info.policyName)\(preposition2) 지금 바로 신청 가능해요"
                        self?.titleLabel.text = title
                    }
                }

                self?.tableView.reloadData()
            }.store(in: &cancellable)
        
        interestButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                
                guard let self,
                let detailInfo = viewModel.detailInfo.value else { return }
                
                Task {
                    do {
                        if self.viewModel.detailInfo.value?.interestFlag == true {
                            try await self.viewModel.removeInterestPolicy(policyId: detailInfo.policyId)
                        } else {
                            try await self.viewModel.addInterestPolicy(policyId: detailInfo.policyId)
                        }
                    } catch {
                        if case CommonError.alreadyInterestingPolicy = error {
                            ToastView.showToast("이미 등록된 관심 정책입니다")
                        } else {
                            ToastView.showToast("알 수 없는 에러로 실패하였습니다.")
                        }
                    }
                }
            }.store(in: &cancellable)
        
        applyButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let url = self?.viewModel.detailInfo.value?.referenceSite else {
                    ToastView.showToast("유효하지 않은 주소입니다.")
                    return
                }
                
                if url.hasPrefix("https") {
                    self?.openSafari(urlString: url)
                } else if url.hasPrefix("http") {
                    let alert = StandardAlertController(title: "보안되지 않은 사이트 입니다.", message: "Safari를 통해 여시겠습니까?")
                    let open = StandardAlertAction(title: "열기", style: .basic, handler: { _ in
                        Utils.openExternalLink(urlStr: self?.viewModel.detailInfo.value?.referenceSite ?? "")
                    })
                    let cancel = StandardAlertAction(title: "취소", style: .cancel)
                    alert.addAction(cancel, open)
                    
                    self?.present(alert, animated: false)
                } else {
                    ToastView.showToast("유효하지 않은 주소입니다.")
                }
            }.store(in: &cancellable)
        
        detailFetchButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let url = self?.viewModel.detailInfo.value?.referenceSite else {
                    ToastView.showToast("유효하지 않은 주소입니다.")
                    return
                }
                
                if url.hasPrefix("https") {
                    self?.openSafari(urlString: url)
                } else if url.hasPrefix("http") {
                    let alert = StandardAlertController(title: "보안되지 않은 사이트 입니다.", message: "Safari를 통해 여시겠습니까?")
                    let open = StandardAlertAction(title: "열기", style: .basic, handler: { _ in
                        Utils.openExternalLink(urlStr: self?.viewModel.detailInfo.value?.referenceSite ?? "")
                    })
                    let cancel = StandardAlertAction(title: "취소", style: .cancel)
                    alert.addAction(cancel, open)
                    
                    self?.present(alert, animated: false)
                } else {
                    ToastView.showToast("유효하지 않은 주소입니다.")
                }
            }.store(in: &cancellable)
        
        viewModel.error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if case CommonError.serverError = error {
                    self?.errorView.isHidden = false
                    self?.errorView.titleLabel.text = "복지 정책을 불러올 수 없어요."
                    self?.errorView.contentLabel.text = "인터넷 연결이 안 되어 있어요!"
                } else {
                    self?.errorView.isHidden = false
                    self?.errorView.titleLabel.text = "복지 정책을 불러올 수 없어요."
                    self?.errorView.contentLabel.text = "요청량이 많아 수행할 수 없었어요"
                }
            }.store(in: &cancellable)
    }
    
    override func addSubView() {
        [tableView, applyButton, detailFetchButton, interestButton, errorView].forEach {
            view.addSubview($0)
        }
        
        [titleLabel, subTitleLabel].forEach {
            titleView.addSubview($0)
        }
    }
    
    override func layout() {
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.width.equalTo(self.view.frame.width-32)
            $0.top.equalToSuperview().offset(8)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-26)
        }
        
        tableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-100)
            $0.top.equalTo(view.safeAreaLayoutGuide)
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
        
        errorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
    }
    
    override func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension WelfareDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.detailInfo.value == nil ? 0 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WelfareDetailCell.identifier, for: indexPath) as! WelfareDetailCell
        guard let policyInfo = viewModel.detailInfo.value else {
            return cell
        }
        
        switch indexPath.row {
        case 0:
            cell.configureCell(title: "서비스 소개",
                               content: policyInfo.policyIntroduction)
        case 1:
            cell.configureCell(title: "신청 서류",
                               content: policyInfo.policyApplyDocument)
        case 2:
            cell.configureCell(title: "신청 방법",
                               content: policyInfo.policyApplyMethod)
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: WelfareDetailDateTypeCell.identifier, for: indexPath) as! WelfareDetailDateTypeCell
            cell.configureCell(title: "신청 기간",
                               dateType: PolicyDateType(rawValue: policyInfo.policyDateType) ?? .blank)
            
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return titleView
    }
}
