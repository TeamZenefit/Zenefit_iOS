//
//  HomeViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import UIKit
import Kingfisher

final class HomeViewController: BaseViewController {
    private let viewModel: HomeViewModel
    
    private let notiItem = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "alarm_off")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private let scollView = UIScrollView()
    
    private let homeHeaderView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let topBGView = UIImageView(image: .init(named: "img_bg")).then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let progressView = ProgressView()
    
    private let nameLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .textNormal
        $0.font = .pretendard(.title1)
    }
    
    private let imageView = UIImageView(image: .init(named: "m-smart"))
    
    private let bookmarkInfoView = SmallBoxView(title: "관심 등록",
                                                icon: .init(resource: .search28))
    
    private let benefitInfoView = SmallBoxView(title: "수혜 정책",
                                               icon: .init(resource: .gift28))
    
    private lazy var smallBoxStackView = UIStackView(arrangedSubviews: [bookmarkInfoView, benefitInfoView]).then {
        $0.distribution = .fillEqually
        $0.spacing = 8
    }

    private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.showsVerticalScrollIndicator = false
        $0.tableHeaderView = homeHeaderView
        $0.separatorStyle = .none
        $0.backgroundColor = .backgroundPrimary
        $0.register(HomePolicyCell.self, forCellReuseIdentifier: HomePolicyCell.identifier)
    }
    
    private lazy var errorView = DefaultErrorView().then {
        $0.retryHandler = { [weak self] in
            self?.viewModel.fetchMainInfo()
        }
        $0.isHidden = true
    }
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(KeychainManager.read("accessToken"))
    }
    
    override func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchMainInfo()
    }
    
    override func setupBinding() {
        viewModel.info
            .receive(on: RunLoop.main)
            .sink { [weak self] info in
                guard let info else { return }
                self?.errorView.isHidden = true
                self?.nameLabel.text = "\(info.nickname)님은\n\(info.characterNickname)(이)에요"
                self?.nameLabel.setPointTextAttribute(info.characterNickname, color: .primaryNormal)
                self?.progressView.configureView(content: info.description,
                                                 value: CGFloat(info.characterPercent)/100.0)
                self?.bookmarkInfoView.configureInfo(count: info.interestPolicyCnt)
                self?.benefitInfoView.configureInfo(count: info.applyPolicyCnt)
                self?.imageView.kf.setImage(with: URL(string: info.characterImage),
                                            placeholder: UIImage(resource: .mSmart))
                
                self?.view.layoutIfNeeded()
                self?.tableView.reloadData()
            }.store(in: &cancellable)
        
        viewModel.error
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                if case CommonError.serverError = error {
                    self?.errorView.isHidden = false
                    self?.errorView.titleLabel.text = "홈 정보를 불러올 수 없어요."
                    self?.errorView.contentLabel.text = "인터넷 연결이 안 되어 있어요!"
                } else {
                    self?.errorView.isHidden = false
                    self?.errorView.titleLabel.text = "알 수 없는 에러가 발생했습니다."
                    self?.errorView.contentLabel.text = "잠시 후 다시 시도해 주세요."
                }
            }.store(in: &cancellable)
    }
    
    override func configureUI() {
        view.backgroundColor = .backgroundPrimary
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIImageView(image: .init(named: "logotype")))
        navigationItem.standardAppearance?.backgroundColor = .backgroundPrimary
        navigationItem.scrollEdgeAppearance?.backgroundColor = .backgroundPrimary
        
        let manualItem = UIButton().then {
            $0.setImage(UIImage(named: "manual_on")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        notiItem.addAction(.init(handler: { [weak self] _ in
            self?.viewModel.coordinator?.setAction(.notiList)
        }), for: .touchUpInside)
        
        manualItem.tapPublisher
            .sink { [weak self] in
                self?.viewModel.coordinator?.setAction(.menual)
            }.store(in: &cancellable)

        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 8

        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: notiItem),
                                                   spacer,
                                                   UIBarButtonItem(customView: manualItem)]
    }
    
    override func setGesture() {
        bookmarkInfoView.gesturePublisher(for: .tap)
            .sink { [weak self] _ in
                self?.viewModel.coordinator?.setAction(.bookmark)
            }.store(in: &cancellable)
        
        benefitInfoView.gesturePublisher(for: .tap)
            .sink { [weak self] _ in
                self?.viewModel.coordinator?.setAction(.benefit)
            }.store(in: &cancellable)
        
//        policyInfoView.tapEventHandler = { [weak self] in
//            self?.tabBarController?.selectedIndex = 1
//        }
//        
//        deadLineInfoView.tapEventHandler = { [weak self] in
//            self?.tabBarController?.selectedIndex = 2
//        }
    }
    
    override func addSubView() {
        view.addSubview(errorView)
        view.addSubview(homeHeaderView)
        
        [topBGView, nameLabel, imageView, progressView, smallBoxStackView].forEach {
            homeHeaderView.addSubview($0)
        }
        
        [tableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func layout() {
        tableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview()
        }
        
        homeHeaderView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        topBGView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(80)
            $0.top.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(40)
            $0.top.equalTo(topBGView.snp.bottom).offset(8)
        }
        
        imageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-40)
            $0.height.width.equalTo(120)
            $0.bottom.equalTo(progressView.snp.top)
        }
        
        progressView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        
        smallBoxStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(progressView.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        errorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            viewModel.info.value?.recommendPolicy.count ?? 0
        default:
            viewModel.info.value?.endDatePolicy.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: HomeSectionHeaderView
        switch section {
        case 0:
            headerView = HomeSectionHeaderView(title: "정책 추천", action: { [weak self] in
                self?.tabBarController?.selectedIndex = 1
            })
        default:
            headerView = HomeSectionHeaderView(title: "신청 마감일", action: { [weak self] in
                self?.tabBarController?.selectedIndex = 2
            })
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomePolicyCell.identifier, for: indexPath) as! HomePolicyCell
        
        guard let info = viewModel.info.value else {
            return cell
        }
        
        switch indexPath.section {
        case 0:
            let item = info.recommendPolicy[indexPath.row]
            cell.configureCell(item: item, showDate: false)
        default:
            let item = info.endDatePolicy[indexPath.row]
            cell.configureCell(item: item, showDate: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return HomeSectionFooterView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let info = viewModel.info.value else {
            return
        }
        
        switch indexPath.section {
        case 0:
            let policyId = info.recommendPolicy[indexPath.row].policyID
            viewModel.coordinator?.setAction(.welfareDetail(welfareId: policyId))
        default:
            let policyId = info.endDatePolicy[indexPath.row].policyID
            viewModel.coordinator?.setAction(.welfareDetail(welfareId: policyId))
        }
    }
}
