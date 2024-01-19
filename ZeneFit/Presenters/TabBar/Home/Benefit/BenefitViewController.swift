//
//  BenefitViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/02.
//

import UIKit

final class BenefitViewController: BaseViewController {
    private let viewModel: BenefitViewModel
    
    private let refreshControl = UIRefreshControl()
    
    private let editButton = UIButton().then {
        $0.setImage(.init(named: "i-wr-28")?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.setImage(.init(named: "i-wr-28-del")?.withRenderingMode(.alwaysOriginal), for: .selected)
    }
    
    private let topFrameView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let subTitleLabel = BaseLabel().then {
        $0.text = "수혜중인 정책"
        $0.font = .pretendard(.body2)
        $0.textColor = .textNormal
    }
    
    private let benefitCountLabel = BaseLabel().then {
        $0.text = "n개"
        $0.font = .pretendard(.body2)
        $0.textColor = .textNormal
    }
    
    private let deleteAllButton = UIButton(type: .system).then {
        $0.setTitle("전체 삭제", for: .normal)
        $0.setTitleColor(.alert, for: .normal)
        $0.titleLabel?.font = .pretendard(.label4)
    }
    
    private lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(BenefitCell.self, forCellReuseIdentifier: BenefitCell.identifier)
        $0.backgroundColor = .backgroundPrimary
        $0.refreshControl = refreshControl
    }
    
    init(viewModel: BenefitViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getbenefitList()
    }
    
    override func setupBinding() {
        editButton.tapPublisher.sink { [weak self] in
            self?.viewModel.isEditMode.toggle()
        }.store(in: &cancellable)
        
        viewModel.$isEditMode
            .sink { [weak self] isEditMode in
                self?.changeEditMode(isEditMode: isEditMode)
                self?.tableView.reloadData()
            }.store(in: &cancellable)
        
        viewModel.policyList
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }.store(in: &cancellable)
        
        viewModel.$totalPolicy
            .receive(on: RunLoop.main)
            .sink { [weak self] count in
                self?.benefitCountLabel.text = "\(count)개"
            }.store(in: &cancellable)
        
        deleteAllButton.tapPublisher
            .sink { [weak self] in
                self?.deleteAllNotification()
            }.store(in: &cancellable)
        
        viewModel.error
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.refreshControl.endRefreshing()
                self?.notiAlert("알 수 없는 에러가 발생했습니다.")
            }.store(in: &cancellable)
        
        refreshControl.controlPublisher(for: .valueChanged)
            .sink { [weak self] _ in
                self?.viewModel.getbenefitList()
            }.store(in: &cancellable)
    }
    
    private func changeEditMode(isEditMode: Bool) {
        editButton.isSelected = isEditMode
        benefitCountLabel.isHidden = isEditMode
        subTitleLabel.isHidden = isEditMode
        deleteAllButton.isHidden = !isEditMode
        tableView.reloadData()
    }
    
    override func configureUI() {
        view.backgroundColor = .backgroundPrimary
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        setTitle = "수혜 정책"
        
        navigationItem.rightBarButtonItem = .init(customView: editButton)
    }
    
    override func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func addSubView() {
        [topFrameView, tableView].forEach {
            view.addSubview($0)
        }
           
        [subTitleLabel, benefitCountLabel, deleteAllButton].forEach {
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
        
        benefitCountLabel.snp.makeConstraints {
            $0.trailing.top.equalToSuperview().inset(16)
        }
        
        deleteAllButton.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(16)
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
        return viewModel.policyList.value.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let policyId = viewModel.policyList.value[indexPath.row].policyID
        viewModel.coordinator?.setAction(.welfareDetail(welfareId: policyId))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BenefitCell.identifier, for: indexPath) as! BenefitCell
        cell.configureCell(policyItem: viewModel.policyList.value[indexPath.row],
                           isEditMode: viewModel.isEditMode)
        cell.deleteButtonTapped = { [weak self] policyId in
            self?.deleteNotification(policyId: policyId)
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        viewModel.didScroll(offsetY: offsetY,
                            contentHeight: contentHeight,
                            frameHeight: frameHeight)
    }
}


extension BenefitViewController {
    private func deleteNotification(policyId: Int) {
        let alert = StandardAlertController(title: "수혜 정책을 삭제할까요?",
                                            message: "삭제하면 정책이 다시 추천될 수도 있어요")
        let cancel = StandardAlertAction(title: "아니오", style: .cancel)
        let delete = StandardAlertAction(title: "삭제하기", style: .basic) { [weak self] _ in
            self?.viewModel.deleteApplying(policyId: policyId)
            self?.viewModel.isEditMode.toggle()
        }
        
        alert.addAction(cancel, delete)
        
        self.present(alert, animated: false)
    }
    
    private func deleteAllNotification() {
        let alert = StandardAlertController(title: "모두 삭제할까요?",
                                            message: nil)
        let cancel = StandardAlertAction(title: "아니오", style: .cancel)
        let delete = StandardAlertAction(title: "삭제하기", style: .basic) { [weak self] _ in
            self?.viewModel.deleteApplying(policyId: nil)
            self?.viewModel.isEditMode.toggle()
        }
        
        alert.addAction(cancel, delete)
        
        self.present(alert, animated: false)
    }
}
