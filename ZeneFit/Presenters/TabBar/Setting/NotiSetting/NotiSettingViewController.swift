//
//  NotiSettingViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import UIKit

final class NotiSettingViewController: BaseViewController {
    private let viewModel: NotiSettingViewModel
    
    private let applyScheduleNotiItemView = NotiSettingItemView(
        title: "신청 일정 알림",
        subTitle: "일주일 전, 3일 전, 1일 전 알림")
    
    init(viewModel: NotiSettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        setTitle = "알림 설정"
        
        backButtonHandler = { [weak self] in
            self?.viewModel.coordinator?.finish()
        }
    }
    
    override func setupBinding() {
        viewModel.$notificationState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.applyScheduleNotiItemView.isOn = state
            }.store(in: &cancellable)
        
        applyScheduleNotiItemView.notiSwitch.controlPublisher(for: .valueChanged)
            .sink { [weak self] state in
                guard let self else { return }
                viewModel.updateNotificationState(isOn: applyScheduleNotiItemView.notiSwitch.isOn)
            }.store(in: &cancellable)
        
        viewModel.error
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.notiAlert("알 수 없는 에러가 발생했습니다.")
            }.store(in: &cancellable)
    }
    
    override func addSubView() {
        [applyScheduleNotiItemView].forEach {
            view.addSubview($0)
        }
    }
    
    override func layout() {
        applyScheduleNotiItemView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
}
