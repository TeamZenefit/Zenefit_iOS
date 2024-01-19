//
//  AppInfoViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import UIKit

final class AppInfoViewController: BaseViewController {
    private let viewModel: AppInfoViewModel
    
    private let diamondImageView = UIImageView().then {
        $0.image = .init(resource: .diamond)
    }
    
    private let subGuideLabel = BaseLabel().then {
        $0.text = "이 앱을 만든 사람들"
        $0.textColor = .textAlternative
        $0.font = .pretendard(.chips)
    }
    
    private let mainLabel = BaseLabel().then {
        $0.text = "저희는 IT 연합 동아리 CMC의\n보물찾기 팀입니다"
        $0.font = .pretendard(.label3)
        $0.textAlignment = .center
        $0.textColor = .textNormal
        $0.numberOfLines = 0
        $0.setPointTextAttribute("보물찾기", color: .primaryNormal)
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .backgroundPrimary
    }
    
    private let appVersionItemView = SettingItemView(title: "앱 버전").then {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        $0.contentTextFont = .pretendard(.body2)
        $0.contentTextColor = .textAlternative
        $0.isHiddenDisclosure = true
        $0.setContent(content: version + "   ")
    }
    
    private let snsItemView = SettingItemView(title: "SNS", content: "instargram").then {
        $0.contentTextFont = .pretendard(.body2)
        $0.contentTextColor = .textAlternative
        $0.disclosureColor = .textAlternative
    }
    
    init(viewModel: AppInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubView() {
        [diamondImageView, subGuideLabel, mainLabel, dividerView, appVersionItemView, snsItemView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupBinding() {
        snsItemView.gesturePublisher(for: .tap)
            .sink { _ in
                guard let url = URL(string: "https://www.instagram.com/zenefit_official/?utm_source=ig_web_button_share_sheet&igshid=OGQ5ZDc2ODk2ZA==")
                else { return }
                UIApplication.shared.open(url, options: [:]) { _ in }
            }.store(in: &cancellable)
    }
    
    override func layout() {
        diamondImageView.snp.makeConstraints {
            $0.size.equalTo(120)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28)
            $0.centerX.equalToSuperview()
        }
        
        subGuideLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(diamondImageView.snp.bottom).offset(12)
        }
        
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(subGuideLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(12)
            $0.top.equalTo(mainLabel.snp.bottom).offset(20)
        }
        
        appVersionItemView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(dividerView.snp.bottom)
        }
        
        snsItemView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(appVersionItemView.snp.bottom)
        }
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        setTitle = "앱 정보"
    }
}
