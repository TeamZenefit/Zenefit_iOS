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
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.clipsToBounds = false
        $0.showsVerticalScrollIndicator = false
        $0.sectionFooterHeight = 0
        $0.separatorStyle = .none
        $0.sectionHeaderTopPadding = 0
        $0.register(WelfareCell.self, forCellReuseIdentifier: WelfareCell.identifier)
        $0.backgroundColor = .white
        $0.isSkeletonable = true
        $0.tableHeaderView = headerView
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
        [tableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupBinding() {
        viewModel.policyList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
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
    }
    
    override func layout() {
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.bottom.horizontalEdges.equalToSuperview()
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
    func toggleCalendarStatus() {
        self.notiAlert("달력에 추가되었습니다.")
    }
    
    func tapApplyWelfare() {
        viewModel.coordinator?.setAction(.detail(id: 0)) // 임시
    }
}

extension WelfareListViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return WelfareCell.identifier
    }
}
