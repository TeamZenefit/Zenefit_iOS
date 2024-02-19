//
//  ScheduleViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import UIKit
import FSCalendar

final class ScheduleViewController: BaseViewController {
    var isEditMode: Bool = false
    
    private let viewModel: ScheduleViewModel
    
    private let policyHeaderView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let tableViewSectionHeaderView = CalendarSectionHedaer()
    
    private let calendarFrameView = UIView().then {
        $0.backgroundColor = .backgroundPrimary
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .white
    }
    
    private lazy var calendarHeaderView = CalendarHeaderView().then {
        let month = Calendar.current.component(.month, from: self.calendarView.currentPage)
        $0.yearMonthLabel.text = "\(month)월"
    }
    
    private lazy var calendarView = FSCalendar().then {
        $0.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.identifier)
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .white
        $0.appearance.titleFont = .pretendard(.body1)
        $0.appearance.selectionColor = .none
        $0.appearance.titleSelectionColor = .textNormal
        $0.appearance.weekdayTextColor = .textAlternative
        $0.appearance.eventSelectionColor = .primaryNormal
        $0.appearance.titleTodayColor = .primaryNormal
        $0.appearance.todayColor = .primaryAssistive
        $0.headerHeight = .zero
        $0.locale = .init(identifier: "ko")
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .lineAlternative
    }
    
    private let eventGuideView = EventGuideView()
    
    private let notiButton = UIButton(type: .system).then {
        $0.setImage(.init(named: "alarm_off")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private lazy var policyTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .backgroundPrimary
        $0.tableHeaderView = policyHeaderView
        $0.separatorStyle = .none
        $0.layer.cornerRadius = 8
        $0.showsVerticalScrollIndicator = false
        $0.register(CalendarPolicyCell.self, forCellReuseIdentifier: CalendarPolicyCell.identifier)
        $0.estimatedSectionHeaderHeight = 81
    }
    
    
    init(viewModel: ScheduleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setDelegate() {
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarHeaderView.delegate = self
        policyTableView.delegate = self
        policyTableView.dataSource = self
    }
    
    override func configureUI() {
        view.backgroundColor = .backgroundPrimary
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        self.navigationController?.navigationBar.isHidden = false
        let titleLabel = UILabel().then {
            $0.text = "달력"
            $0.textColor = .textStrong
            $0.font = .pretendard(.title1)
        }
        
        navigationItem.standardAppearance?.backgroundColor = .backgroundPrimary
        navigationItem.scrollEdgeAppearance?.backgroundColor = .backgroundPrimary
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = .init(customView: notiButton)
        
        notiButton.addAction(.init(handler: { [weak self] _ in
            self?.viewModel.coordinator?.setAction(.notiList)
        }), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let year = Calendar.current.component(.year, from: self.calendarView.currentPage)
        let month = Calendar.current.component(.month, from: self.calendarView.currentPage)
        viewModel.getPolicy(year: year, month: month)
        tableViewSectionHeaderView.month = "\(month)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        endEditingMode()
    }
    
    override func addSubView() {
        policyHeaderView.addSubview(calendarFrameView)
        
        [policyTableView].forEach {
            view.addSubview($0)
        }
        
        [calendarHeaderView, calendarView, separatorView, eventGuideView].forEach {
            calendarFrameView.addSubview($0)
        }
    }
    
    override func layout() {
        policyHeaderView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
        }
        
        calendarFrameView.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        policyTableView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        
        calendarHeaderView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(20)
            $0.width.equalTo(UIScreen.main.bounds.width-64)
        }
        
        calendarView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(calendarHeaderView.snp.bottom).offset(24)
            $0.height.equalTo(300)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(calendarView.snp.bottom).offset(12)
        }
        
        eventGuideView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
    
    override func setupBinding() {
        viewModel.policyList
            .receive(on: RunLoop.main)
            .sink { [weak self] info in
                self?.tableViewSectionHeaderView.count = "\(info.count)"
                self?.policyTableView.reloadData()
                self?.calendarView.reloadData()
            }.store(in: &cancellable)
        
        tableViewSectionHeaderView.editButton.tapPublisher
            .sink { [weak self] in
                guard let self else { return }
                isEditMode.toggle()
                tableViewSectionHeaderView.editButton.isSelected = isEditMode
                policyTableView.reloadData()
                calendarView.reloadData()
            }.store(in: &cancellable)
    }
    
    private func endEditingMode() {
        isEditMode = false
        tableViewSectionHeaderView.editButton.isSelected = false
        policyTableView.reloadData()
    }
    
    private func deleteNotification(policyId: Int) {
        let alert = StandardAlertController(title: "정책 일정을 삭제할까요?",
                                            message: "삭제한 정책은 관심 등록에서도 제거돼요!")
        let cancel = StandardAlertAction(title: "아니오", style: .cancel)
        let delete = StandardAlertAction(title: "삭제하기", style: .basic) { [weak self] _ in
            self?.viewModel.deleteBookmark(policyId: policyId)
            self?.endEditingMode()
        }
        
        alert.addAction(cancel, delete)
        
        self.present(alert, animated: false)
    }
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.policyList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalendarPolicyCell.identifier, for: indexPath) as! CalendarPolicyCell
        let item = viewModel.policyList.value[indexPath.row]
        cell.delegate = self
        cell.configureCell(policy: item, isEditMode: isEditMode)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if viewModel.policyList.value.count > 0 {
            return tableViewSectionHeaderView
        } else {
            return nil
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        if date.formattedString == Date.now.formattedString {
            return .primaryAssistive
        } else {
            return .none
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        if date.formattedString == Date.now.formattedString {
            return .primaryNormal
        } else {
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if viewModel.policyList.value.count > 0 {
            let bottomFrameView = UIView()
            bottomFrameView.backgroundColor = .white
            bottomFrameView.layer.cornerRadius = 16
            bottomFrameView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            return bottomFrameView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        20
    }
}

extension ScheduleViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        endEditingMode()
        
        let thisYear = Calendar.current.component(.year, from: Date.now)
        let year = Calendar.current.component(.year, from: calendar.currentPage)
        let month = Calendar.current.component(.month, from: calendar.currentPage)
        
        if thisYear == year {
            calendarHeaderView.yearMonthLabel.text = "\(month)월"
        } else {
            calendarHeaderView.yearMonthLabel.text = "\(year)년 \(month)월"
        }
        tableViewSectionHeaderView.month = "\(month)"
        viewModel.getPolicy(year: year, month: month)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventOffsetFor date: Date) -> CGPoint {
        return .init(x: 0, y: -6)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let isContain = viewModel.policyList.value.contains(where: {
            $0.applyEndDate == date.formattedString ||
            $0.applySttDate == date.formattedString
        })
        
        return isContain ? 1 : 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        endEditingMode()
        
        let strDatePolicy = viewModel.policyList.value.filter { $0.applySttDate == date.formattedString }
        let endDatePolicy = viewModel.policyList.value.filter { $0.applyEndDate == date.formattedString }
        
        if (strDatePolicy + endDatePolicy).isNotEmpty {
            viewModel.coordinator?.setAction(.policyOfDay(date: date,
                                                          strDatePolicy: strDatePolicy,
                                                          endDatePolicy: endDatePolicy))
        } else {
//            notiAlert("해당 날짜에 신청 가능한 정책이 없어요.")
        }   
    }
}

extension ScheduleViewController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        if date.formattedString == Date.now.formattedString {
            
        } else {
            calendar.appearance.titleFont = .pretendard(.body1)
        }
        
        return nil
    }
}

extension ScheduleViewController: CalendarHeaderDelegate {
    func tapPreviousMonth() {
        let currentPage = calendarView.currentPage
        guard let previousMonth = Calendar.current.date(
            byAdding: .month,
            value: -1,
            to: currentPage
        ) else {
            return
        }
        calendarView.setCurrentPage(previousMonth, animated: true)
    }
    
    func tapNextMonth() {
        let currentPage = calendarView.currentPage
        guard let nextMonth = Calendar.current.date(
            byAdding: .month,
            value: 1,
            to: currentPage
        ) else {
            return
        }
        calendarView.setCurrentPage(nextMonth, animated: true)
    }
}

extension ScheduleViewController: CalendarPolicyCellDelegate {
    func tapApply(policyId: Int) {
        viewModel.coordinator?.setAction(.welfareDetail(policyId: policyId))
    }
    
    func tapDelete(policyId: Int) {
        deleteNotification(policyId: policyId)
    }
}
