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
    
    private let editButton = UIButton().then {
        $0.setImage(.init(named: "i-wr-28")?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.setImage(.init(named: "i-wr-28-del")?.withRenderingMode(.alwaysOriginal), for: .selected)
    }
    
    private let topFrameView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "관심 등록 중인 정책"
        $0.font = .pretendard(.body2)
        $0.textColor = .textNormal
    }
    
    private let bookmarkCountLabel = UILabel().then {
        $0.text = "n개"
        $0.font = .pretendard(.body2)
        $0.textColor = .textNormal
    }
    
    private let deleteAllButton = UIButton(type: .system).then {
        $0.setTitle("전체 삭제", for: .normal)
        $0.setTitleColor(.alert, for: .normal)
        $0.titleLabel?.font = .pretendard(.label4)
    }
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.separatorStyle = .none
        $0.register(BookmarkCell.self, forCellReuseIdentifier: BookmarkCell.identifier)
        $0.backgroundColor = .backgroundPrimary
    }
    
    init(viewModel: BookmarkViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            .sink { [weak self] isEditMode in
                self?.changeEditMode(isEditMode: isEditMode)
                self?.tableView.reloadData()
            }.store(in: &cancellable)
        
        viewModel.bookmarkList
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }.store(in: &cancellable)
        
        viewModel.$totalPolicy
            .sink { [weak self] count in
                self?.bookmarkCountLabel.text = "\(count)개"
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
        let footer = BookmarkFooterView()
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
