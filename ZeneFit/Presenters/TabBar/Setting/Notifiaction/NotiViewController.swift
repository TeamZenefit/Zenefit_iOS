//
//  NotiViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import UIKit

// TODO: order 정렬필요
final class NotiViewController: BaseViewController {
    private let viewModel: NotiViewModel
    
    private let refreshControl = UIRefreshControl()
    
    private let notiSetting = UIButton(type: .system).then {
        $0.setImage(.init(resource: .setting).withRenderingMode(.alwaysOriginal),
                    for: .normal)
    }
    
    private let categoryCollectionView = UICollectionView(frame: .zero,
                                                          collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(NotificationCategoryCell.self, forCellWithReuseIdentifier: NotificationCategoryCell.identifier)
        $0.backgroundColor = .white
        $0.contentInset = .init(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .lineNormal
    }
    
    private lazy var tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.refreshControl = refreshControl
        $0.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identifier)
    }
    
    private let footerView = ZFTableViewFooterView(title: "2주가 지난 알림은 사라져요", type: .fill)
    
    init(viewModel: NotiViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupBinding() {
        notiSetting.tapPublisher
            .sink { [weak self] in
                self?.viewModel.coordinator?.setAction(.notiSetting)
            }.store(in: &cancellable)
        
        viewModel.notificationList
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }.store(in: &cancellable)
        
        refreshControl.controlPublisher(for: .valueChanged)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.viewModel.getNotificationInfo()
                self?.refreshControl.endRefreshing()
            }.store(in: &cancellable)
        
        viewModel.error
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.refreshControl.endRefreshing()
                self?.notiAlert("알 수 없는 에러가 발생했습니다.")
            }.store(in: &cancellable)
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        setTitle = "알림 내역"
        navigationItem.rightBarButtonItem = .init(customView: notiSetting)
    
        backButtonHandler = { [weak self] in
            self?.viewModel.coordinator?.finish()
        }
    }
    
    override func setDelegate() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func addSubView() {
        [categoryCollectionView, dividerView, tableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        footerView.frame = .init(origin: .init(x: 0, y: 0),
                                 size: .init(width: view.frame.width, height: 42))
        tableView.tableFooterView = footerView
    }
    
    override func layout() {
        categoryCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.height.equalTo(32)
        }
        
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(12)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

extension NotiViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationCategoryCell.identifier, for: indexPath) as! NotificationCategoryCell
        cell.configureCell(title: viewModel.categories[indexPath.row].description,
                           selectedCategory: viewModel.selectedCategory.description)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedCategory = viewModel.categories[indexPath.row]
        collectionView.reloadSections(.init(integer: 0))
    }
}

extension NotiViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = viewModel.categories[indexPath.row]
        let mockLabel = PaddingLabel(padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        mockLabel.font = .pretendard(.body2)
        mockLabel.text = item.description
        
        return .init(width: mockLabel.intrinsicContentSize.width, height: 32)
    }
}

extension NotiViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.notificationList.value.count
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        " "
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier,
                                                 for: indexPath) as! NotificationCell
        let item = viewModel.notificationList.value[indexPath.row]
        cell.configureCell(item: item)
        
        return cell
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
