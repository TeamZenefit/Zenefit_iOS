//
//  SelectionBottomSheet.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/01.
//

import UIKit
import Combine

final class SelectionBottomSheet: UIView {
    private var cancellable = Set<AnyCancellable>()
    var completion: ((String?)->Void)?
    
    @Published var list: [String] = []
    var selectedItem: String?
    
    private let backgroundBlurView = UIView().then {
        $0.backgroundColor = .textNormal.withAlphaComponent(0.7)
    }
    
    private let frameView = UIView().then {
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .textNormal
        $0.font = .pretendard(.label1)
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "Close"), for: .normal)
    }
    
    private let duplicateInfoLabel = UILabel().then {
        $0.textColor = .alert
        $0.text = "중복선택 할 수 없습니다"
        $0.font = .pretendard(.chips)
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .lineNormal
    }
    
    private let tableView = UITableView().then {
        $0.register(SelectionCell.self, forCellReuseIdentifier: SelectionCell.identifier)
        $0.separatorStyle = .none
        $0.backgroundColor = .white
    }
    
    init(title: String, list: [String], selectedItem: String?, completion: ((String?)->Void)? = nil) {
        titleLabel.text = title
        self.list = list
        self.selectedItem = selectedItem
        self.completion = completion
        super.init(frame: .zero)
        
        addSubViews()
        layout()
        setUpBinding()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpBinding() {
        $list
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellable)
        
        closeButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.completion?(nil)
                self?.removeFromSuperview()
            }
            .store(in: &cancellable)
    }
    
    static func showBottomSheet(view: UIView, title: String, list: [String], selectedItem: String?, completion: ((String?)->Void)?) {
        let bottomSheet = SelectionBottomSheet(title: title,
                                               list: list,
                                               selectedItem: selectedItem,
                                               completion: completion)
        
        view.addSubview(bottomSheet)
        bottomSheet.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func addSubViews() {
        [backgroundBlurView, frameView].forEach {
            addSubview($0)
        }
        
        [titleLabel, duplicateInfoLabel, dividerView, tableView, closeButton].forEach {
            frameView.addSubview($0)
        }
    }
    
    private func layout() {
        backgroundBlurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        frameView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.45)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(24)
        }
        
        closeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.width.equalTo(24)
            $0.centerY.equalTo(titleLabel)
        }
        
        duplicateInfoLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
        }
        
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(1)
            $0.top.equalTo(duplicateInfoLabel.snp.bottom).offset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(dividerView.snp.bottom).offset(12)
            $0.bottom.equalToSuperview().offset(-44)
        }
    }
}

extension SelectionBottomSheet: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectionCell.identifier, for: indexPath) as! SelectionCell
        let item = list[indexPath.row]
        let isSelected = selectedItem == item
        cell.configureCell(item: item, isSelected: isSelected)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = list[indexPath.row]
        selectedItem = item
        completion?(selectedItem ?? "")
        self.removeFromSuperview()
    }
}
