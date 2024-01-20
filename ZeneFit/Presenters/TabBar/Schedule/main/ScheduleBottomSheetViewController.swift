//
//  ScheduleBottomSheetViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/20/24.
//

import UIKit
import Combine

final class ScheduleBottomSheetViewController: BaseViewController {
    weak var coordinator: ScheduleCoordinator?
    var completion: ((String?)->Void)?
    
    var endDatePolicyList: [CalendarPolicyDTO] = []
    var strDatePolicyList: [CalendarPolicyDTO] = []
    
    private let frameView = UIView().then {
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }
    
    private let titleLabel = BaseLabel().then {
        $0.textColor = .textNormal
        $0.font = .pretendard(.label1)
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "Close"), for: .normal)
    }
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(CalendarPolicyCell.self, forCellReuseIdentifier: CalendarPolicyCell.identifier)
        $0.separatorStyle = .none
        $0.backgroundColor = .white
        $0.sectionHeaderTopPadding = 0
    }
    
    init(coordinator: ScheduleCoordinator?, date: Date, endDatePolicyList: [CalendarPolicyDTO], strDatePolicyList: [CalendarPolicyDTO]) {
        self.coordinator = coordinator
        self.endDatePolicyList = endDatePolicyList
        self.strDatePolicyList = strDatePolicyList
        
        
        titleLabel.text = "\(date.month)월 \(date.day)일"
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = .clear
        frameView.transform = .init(translationX: 0, y: UIScreen.main.bounds.height)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0, animations: { [weak self] in
            self?.view.backgroundColor = .textNormal.withAlphaComponent(0.7)
            self?.frameView.transform = .identity
        })
    }
    
    override func setupBinding() {
        
        closeButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.completion?(nil)
                UIView.animate(withDuration: 0.5, animations: { [weak self] in
                    self?.view.backgroundColor = .clear
                    self?.frameView.transform = .init(translationX: 0, y: UIScreen.main.bounds.height)
                }, completion: { [weak self] _ in
                    self?.dismiss(animated: false)
                })
            }
            .store(in: &cancellable)
    }
    
    override func addSubView() {
        [frameView].forEach {
            view.addSubview($0)
        }
        
        [titleLabel, tableView, closeButton].forEach {
            frameView.addSubview($0)
        }
    }
    
    override func layout() {
        frameView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(409)
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
        
        tableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().offset(-44)
        }
    }
}


extension ScheduleBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            strDatePolicyList.count
        } else {
            endDatePolicyList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return strDatePolicyList.count == 0 ? 0 : 22
        } else {
            return endDatePolicyList.count == 0 ? 0 : 22
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        " "
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return strDatePolicyList.count == 0 ? 0 : 20
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = DateTypeHeaderView(title: "신청 시작일")
            return strDatePolicyList.count == 0 ? UIView() : headerView
        } else {
            let headerView = DateTypeHeaderView(title: "신청 마감일")
            return endDatePolicyList.count == 0 ? UIView() : headerView
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalendarPolicyCell.identifier, for: indexPath) as! CalendarPolicyCell
        cell.delegate = self
        let item: CalendarPolicyDTO
        if indexPath.section == 0 {
            item = strDatePolicyList[indexPath.row]
        } else {
            item = endDatePolicyList[indexPath.row]
        }
        
        cell.configureCell(policy: item, isEditMode: false)
        
        return cell
    }
}

extension ScheduleBottomSheetViewController: CalendarPolicyCellDelegate {
    func tapApply(policyId: Int) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.view.backgroundColor = .clear
            self?.frameView.transform = .init(translationX: 0, y: UIScreen.main.bounds.height)
        }, completion: { [weak self] _ in
            self?.dismiss(animated: true) { [weak self] in
                self?.coordinator?.setAction(.welfareDetail(policyId: policyId))
            }
        })
    }
    
    func tapDelete(policyId: Int) { }
}
