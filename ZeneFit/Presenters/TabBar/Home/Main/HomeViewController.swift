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
    
    private let topBGView = UIImageView(image: .init(named: "img_bg"))
    
    private let progressView = ProgressView()
    
    private let nameLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .textNormal
        $0.font = .pretendard(.title1)
        $0.text = "상우님은\n부자되세요"
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
    
    private lazy var policyInfoView = BigBoxView(title: "정책 추천", coordinator: viewModel.coordinator)
    private lazy var deadLineInfoView = BigBoxView(title: "신청 마감일", coordinator: nil)
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchMainInfo()
    }
    
    override func setupBinding() {
        viewModel.info
            .receive(on: RunLoop.main)
            .sink { [weak self] info in
                self?.errorView.isHidden = true
                self?.nameLabel.text = "\(info.nickname)님은\n\(info.characterNickname)(이)에요"
                self?.nameLabel.setPointTextAttribute(info.characterNickname, color: .primaryNormal)
                self?.progressView.configureView(content: info.description,
                                                 value: CGFloat(info.characterPercent)/100.0)
                self?.bookmarkInfoView.configureInfo(count: info.interestPolicyCnt)
                self?.benefitInfoView.configureInfo(count: info.applyPolicyCnt)
                self?.imageView.kf.setImage(with: URL(string: info.characterImage))
                
                self?.policyInfoView.setItems(items: info.recommendPolicy)
                self?.deadLineInfoView.setItems(items: info.endDatePolicy,
                                                hasDday: true)
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
        
        policyInfoView.tapEventHandler = { [weak self] in
            self?.tabBarController?.selectedIndex = 1
        }
        
        deadLineInfoView.tapEventHandler = { [weak self] in
            self?.tabBarController?.selectedIndex = 2
        }
    }
    
    override func addSubView() {
        view.addSubview(scollView)
        view.addSubview(errorView)
        [topBGView, nameLabel, imageView, progressView, smallBoxStackView, policyInfoView, deadLineInfoView].forEach {
            scollView.addSubview($0)
        }
    }
    
    override func layout() {
        scollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topBGView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.width.equalTo(view.frame.width)
            $0.top.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.1)
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
        }
        
        policyInfoView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(smallBoxStackView.snp.bottom).offset(24)
        }
        
        deadLineInfoView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(policyInfoView.snp.bottom).offset(24)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        errorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
