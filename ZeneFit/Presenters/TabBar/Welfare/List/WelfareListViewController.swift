//
//  WelfareListViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/05.
//

import UIKit

final class WelfareListViewController: BaseViewController {
    private let viewModel: WelfareListViewModel
    
    private lazy var searchBar = WelfareSearchBar().then {
        $0.searchTextField.attributedPlaceholder = .init(string: "찾으시려는 복지를 검색하세요.",
                                                         attributes: [.foregroundColor : UIColor.textAlternative,
                                                                      .font : UIFont.pretendard(.body1)])
    }
    
    private lazy var categoryCollectionView = UICollectionView(frame: .zero,
                                                            collectionViewLayout: createLayout()).then {
        $0.showsHorizontalScrollIndicator = false
        $0.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        $0.backgroundColor = .white
        $0.bounces = false
    }
    
    private let headerView = UIView()
    
    private let sortView = WelfareSortButton(title: "수혜금액")
    
    private let sortContentView = UIView().then {
        $0.backgroundColor = .backgroundPrimary
    }
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.clipsToBounds = false
        $0.showsVerticalScrollIndicator = false
        $0.sectionFooterHeight = 0
        $0.separatorStyle = .none
        $0.sectionHeaderTopPadding = 0
        $0.register(WelfareCell.self, forCellReuseIdentifier: WelfareCell.identifier)
        $0.backgroundColor = .white
    }
    
    init(viewModel: WelfareListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        switch viewModel.type {
        case .cash:
            setTitle = "현금 정책"
        case .loan:
            setTitle = "대출 정책"
        case .social:
            setTitle = "사회 서비스"
        }
    }
    
    override func addSubView() {
        [tableView].forEach {
            view.addSubview($0)
        }
        
        [searchBar, categoryCollectionView, sortView, sortContentView].forEach {
            headerView.addSubview($0)
        }
    }
    
    override func setupBinding() {
        sortView.tapPublisher
            .sink { [weak self] in
                guard let self else { return }
                sortView.isOpen.toggle()
                
                let height = sortView.isOpen ? 56 : 0
                
                self.sortContentView.snp.updateConstraints {
                    $0.height.equalTo(height)
                }
                self.tableView.reloadSections(.init(integer: 0), with: .none)
                
            }.store(in: &cancellable)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func layout() {
        searchBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.height.equalTo(40)
        }
        
        sortView.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(16)
            $0.height.equalTo(32)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        sortContentView.snp.makeConstraints {
            $0.top.equalTo(sortView.snp.bottom).offset(8)
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(0)
            $0.centerX.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setDelegate() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
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
        cell.configureCell(title: viewModel.categories[indexPath.row], selectedCategory: viewModel.selectedCategory)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedCategory = viewModel.categories[indexPath.row]
        collectionView.reloadSections(.init(integer: 0))
    }
}

extension WelfareListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = viewModel.categories[indexPath.row]
        let mockLabel = PaddingLabel(padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        mockLabel.text = item
        
        return .init(width: mockLabel.intrinsicContentSize.width, height: 40)
    }
}

extension WelfareListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        headerView.backgroundColor = .white
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WelfareCell.identifier, for: indexPath) as! WelfareCell
        cell.configureCell(item: viewModel.items[indexPath.row])
        
        return cell
    }
}

extension WelfareListViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        return layout
    }
}
