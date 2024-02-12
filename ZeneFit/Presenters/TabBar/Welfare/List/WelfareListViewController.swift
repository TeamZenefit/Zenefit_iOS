//
//  WelfareListViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/05.
//

import UIKit
import SkeletonView

// TODO: Compositional로 변경
final class WelfareListViewController: BaseViewController {
    private let viewModel: WelfareListViewModel
    
    private let headerView = WelfareListHeaderView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var errorView = DefaultErrorView().then {
        $0.retryHandler = { [weak self] in
            self?.viewModel.getPolicyInfo()
        }
        $0.isHidden = true
    }
    
    private let emptyView = WelfareEmptyView().then {
        $0.isHidden = true
    }
    
    private lazy var tableView = UITableView(frame: .zero).then {
        $0.clipsToBounds = false
        $0.showsVerticalScrollIndicator = false
        $0.sectionFooterHeight = 0
        $0.separatorStyle = .none
        $0.sectionHeaderTopPadding = 0
        $0.register(WelfareCell.self, forCellReuseIdentifier: WelfareCell.identifier)
        $0.backgroundColor = .white
        $0.isSkeletonable = true
        $0.isUserInteractionDisabledWhenSkeletonIsActive = false
        $0.tableHeaderView = headerView
        $0.backgroundView = emptyView
    }
    
    init(viewModel: WelfareListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        headerView.updateHeightHandler = { [ weak self] in
            self?.tableView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .white
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        setTitle = viewModel.type.description
    }
    
    override func addSubView() {
        [tableView, errorView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupBinding() {
        viewModel.policyList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.emptyView.isHidden = list.isNotEmpty
                self?.tableView.reloadData()
                self?.errorView.isHidden = true
            }.store(in: &cancellable)
        
        headerView.searchBar.searchTextField
            .textPublisher.sink { [weak self] keyword in
                self?.viewModel.keyword.send(keyword)
            }.store(in: &cancellable)
        
        headerView.searchBar.searchTextField.controlPublisher(for: .editingDidEnd)
            .sink { [weak self] _ in
                self?.viewModel.getPolicyInfo()
                self?.view.endEditing(false)
            }.store(in: &cancellable)
        
        headerView.sortContentView.$selectedSortType
            .sink { [weak self] type in
                self?.viewModel.sortType.send(type)
            }.store(in: &cancellable)
        
        viewModel.showSkeleton
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isShow in
                isShow ? self?.tableView.showSkeleton(usingColor: .fillAlternative) : self?.tableView.hideSkeleton()
            }.store(in: &cancellable)
        
        viewModel.error
            .receive(on: RunLoop.main)
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
    
    override func layout() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
        
        errorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setDelegate() {
        headerView.categoryCollectionView.delegate = self
        headerView.categoryCollectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension WelfareListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        cell.configureCell(title: viewModel.categories[indexPath.row].description,
                           selectedCategory: viewModel.selectedCategory.value.description)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedCategory.send(viewModel.categories[indexPath.row])
        collectionView.reloadSections(.init(integer: 0))
    }
}

extension WelfareListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = viewModel.categories[indexPath.row]
        let mockLabel = PaddingLabel(padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        mockLabel.font = .pretendard(.label3)
        mockLabel.text = item.description
        
        return .init(width: mockLabel.intrinsicContentSize.width, height: 40)
    }
}

extension WelfareListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.policyList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WelfareCell.identifier, for: indexPath) as! WelfareCell
        cell.configureCell(item: viewModel.policyList.value[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.policyList.value[indexPath.row]
        viewModel.coordinator?.setAction(.detail(id: item.policyId))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView is UITableView {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = tableView.contentSize.height
            let frameHeight = scrollView.frame.height
    
            viewModel.didScroll(offsetY: offsetY,
                                contentHeight: contentHeight,
                                frameHeight: frameHeight)
        }
    }
}

extension WelfareListViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        return layout
    }
}

extension WelfareListViewController: WelfareDelegate {
    func toggleCalendarStatus(policy: PolicyInfoDTO, completion: (() -> Void)?) {
        Task { [weak self] in
            do {
                if policy.interestFlag {
                    try await self?.viewModel.removeInterestPolicy(policyId: policy.policyId)
                    self?.notiAlert("달력에서 제거되었습니다.")
                } else {
                    try await self?.viewModel.addInterestPolicy(policyId: policy.policyId)
                    self?.notiAlert("달력에 추가되었습니다.")
                }
                
                completion?()
            } catch {
                if case CommonError.alreadyInterestingPolicy = error {
                    self?.notiAlert("이미 등록된 관심 정책입니다")
                } else {
                    self?.notiAlert("알 수 없는 에러로 실패하였습니다.")
                }
            }
        }
    }
    
    func tapApplyWelfare(policy: PolicyInfoDTO) {
        guard let url = policy.policyUrl else {
            notiAlert("유효하지 않은 주소입니다.")
            return
        }
        
        if url.hasPrefix("https") {
            openSafari(urlString: url)
        } else if url.hasPrefix("http") {
            let alert = StandardAlertController(title: "보안되지 않은 사이트 입니다.", message: "Safari를 통해 여시겠습니까?")
            let open = StandardAlertAction(title: "열기", style: .blue, handler: { _ in
                Utils.openExternalLink(urlStr: policy.policyUrl ?? "")
            })
            let cancel = StandardAlertAction(title: "취소", style: .cancel)
            alert.addAction(cancel, open)
            
            self.present(alert, animated: false)
        } else {
            notiAlert("유효하지 않은 주소입니다.")
        }
    }
    
    func tapApplyWelfareFlag(policy: PolicyInfoDTO, completion: (() -> Void)?) {
        Task { [weak self] in
            do {
                if policy.applyFlag {
                    try await self?.viewModel.removeApplyingPolicy(policyId: policy.policyId)
                } else {
                    try await self?.viewModel.addApplyingPolicy(policyId: policy.policyId)
                }
                
                completion?()
            } catch {
                if case CommonError.alreadyInterestingPolicy = error {
                    self?.notiAlert("이미 등록된 수혜 정책입니다")
                } else {
                    self?.notiAlert("알 수 없는 에러로 실패하였습니다.")
                }
            }
        }
    }
}

extension WelfareListViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.policyList.value.count + 10
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return WelfareCell.identifier
    }
}
