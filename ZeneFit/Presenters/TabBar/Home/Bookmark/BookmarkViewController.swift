//
//  BookmarkViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/30.
//

import UIKit
import Combine

final class BookmarkViewController: BaseViewController {
    private let viewModel: BookmarkViewModel
    
    private let refreshControl = UIRefreshControl()
    
    private let editButton = UIButton().then {
        $0.setImage(.init(named: "i-wr-28")?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.setImage(.init(named: "i-wr-28-del")?.withRenderingMode(.alwaysOriginal), for: .selected)
    }
    
    private let topFrameView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let subTitleLabel = BaseLabel().then {
        $0.text = "관심 등록 중인 정책"
        $0.font = .pretendard(.body2)
        $0.textColor = .textNormal
    }
    
    private let bookmarkCountLabel = BaseLabel().then {
        $0.text = "n개"
        $0.font = .pretendard(.body2)
        $0.textColor = .textNormal
    }
    
    private let deleteAllButton = UIButton(type: .system).then {
        $0.setTitle("전체 삭제", for: .normal)
        $0.setTitleColor(.alert, for: .normal)
        $0.titleLabel?.font = .pretendard(.label4)
    }
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.separatorStyle = .none
        $0.register(BookmarkCell.self, forCellReuseIdentifier: BookmarkCell.identifier)
        $0.backgroundColor = .backgroundPrimary
        $0.refreshControl = refreshControl
    }
    
    init(viewModel: BookmarkViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getBookmarkList()
    }
    
    override func configureUI() {
        view.backgroundColor = .backgroundPrimary
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        setTitle = "관심 정책"
        
        navigationItem.rightBarButtonItem = .init(customView: editButton)
    }
    
    override func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func setupBinding() {
        editButton.tapPublisher.sink { [weak self] in
            self?.viewModel.isEditMode.toggle()
        }.store(in: &cancellable)
        
        viewModel.$isEditMode
            .receive(on: RunLoop.main)
            .sink { [weak self] isEditMode in
                self?.changeEditMode(isEditMode: isEditMode)
                self?.tableView.reloadData()
            }.store(in: &cancellable)
        
        viewModel.bookmarkList
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }.store(in: &cancellable)
        
        viewModel.$totalPolicy
            .receive(on: RunLoop.main)
            .sink { [weak self] count in
                self?.bookmarkCountLabel.text = "\(count)개"
            }.store(in: &cancellable)
        
        deleteAllButton.tapPublisher
            .sink { [weak self] in
                self?.deleteAllNotification()
            }.store(in: &cancellable)
        
        refreshControl.controlPublisher(for: .valueChanged)
            .sink { [weak self] _ in
                self?.viewModel.getBookmarkList()
            }.store(in: &cancellable)
        
        viewModel.error
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.refreshControl.endRefreshing()
                self?.notiAlert("알 수 없는 에러가 발생했습니다.")
            }.store(in: &cancellable)
    }
    
    private func changeEditMode(isEditMode: Bool) {
        editButton.isSelected = isEditMode
        bookmarkCountLabel.isHidden = isEditMode
        subTitleLabel.isHidden = isEditMode
        deleteAllButton.isHidden = !isEditMode
    }
    
    override func addSubView() {
        [topFrameView, tableView].forEach {
            view.addSubview($0)
        }
           
        [subTitleLabel, bookmarkCountLabel, deleteAllButton].forEach {
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
        
        deleteAllButton.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(16)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(topFrameView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = ZFTableViewFooterView(title: "관심 정책은 달력에도 추가됩니다.")
        footer.frame = .init(x: 16, y: 0, width: 200, height: 34)
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return .init(frame: .init(x: 0, y: 0, width: 20, height: 20))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bookmarkList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkCell.identifier, for: indexPath) as! BookmarkCell
        cell.configureCell(policyItem: viewModel.bookmarkList.value[indexPath.row],
                           isEditMode: viewModel.isEditMode)
        cell.deleteButtonTapped = { [weak self] policyId in
            self?.deleteNotification(policyId: policyId)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let policyId = viewModel.bookmarkList.value[indexPath.row].policyID
        viewModel.coordinator?.setAction(.welfareDetail(welfareId: policyId))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let frameHeight = scrollView.frame.height
     
        viewModel.didScroll(offsetY: offsetY,
                            contentHeight: contentHeight,
                            frameHeight: frameHeight)
    }
}

extension BookmarkViewController {
    private func deleteNotification(policyId: Int) {
        let alert = StandardAlertController(title: "관심 정책을 삭제할까요?",
                                            message: "스크랩한 정책이 달력에서도 제거돼요!")
        let cancel = StandardAlertAction(title: "아니오", style: .cancel)
        let delete = StandardAlertAction(title: "삭제하기", style: .basic) { [weak self] _ in
            self?.viewModel.deleteBookmark(policyId: policyId)
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
            self?.viewModel.deleteBookmark(policyId: nil)
            self?.viewModel.isEditMode.toggle()
        }
        
        alert.addAction(cancel, delete)
        
        self.present(alert, animated: false)
    }
}
