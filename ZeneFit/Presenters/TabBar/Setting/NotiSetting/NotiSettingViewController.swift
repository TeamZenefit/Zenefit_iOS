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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        setTitle = "알림 설정"
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
