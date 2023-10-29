//
//  ManualViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/24.
//

import UIKit

final class ManualViewController: BaseViewController {
    
    private let pageScrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let pageControl = UIPageControl().then {
        $0.numberOfPages = 5
        $0.tintColor = .purple
        $0.currentPage = 0
        $0.pageIndicatorTintColor = .fillDisable
        $0.currentPageIndicatorTintColor = .primaryNormal
        $0.hidesForSinglePage = true
    }
    
    private let contentView = UIView()
    
    private let firstOnboardingView = UIImageView(image: UIImage(named: "ManualOne")?.withRenderingMode(.alwaysOriginal))
    
    private let secondOnboardingView = ManualView(title: "찾아주는 나의 정책",
                                                  subTitle: "입력한 개인정보로 신청 가능 여부를 판단해주고\n예상 수혜 금액이 높은 정책을 먼저 추천드려요!",
                                                  image: .init(named: "ManualTwo"))
    
    private let thirdOnboardingView = ManualView(title: "관심 있는 정책 신청 관리",
                                                 subTitle: "달력에서 신청 시작일과 마감일을 보여드려요\nD-day를 설정하면 Push알림을 보내드려요!",
                                                 image: .init(named: "ManualThree"))
    
    private let fourthOnboardingView = ManualView(title: "나의 유형과 개인 설정",
                                                  subTitle: "나는 혜택을 잘 챙기고 있는지 유형으로 알려줘요!\n개인정보를 추가하면 더 많은 정책을 추천드려요",
                                                  image: .init(named: "ManualFour"))
    
    private let fifthOnboardingView = ManualView(title: "수혜중인 정책 관리",
                                                 subTitle: "이미 수혜중이거나 신청을 완료한 정책은\n체크표시를 눌러 따로 모아 보세요!",
                                                 image: .init(named: "ManualFive"))
    
    private let closeButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "Close")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageScrollView.delegate = self
    }
    
    override func addSubView() {
        [pageScrollView, pageControl, closeButton].forEach {
            view.addSubview($0)
        }
        
        [contentView, firstOnboardingView, secondOnboardingView, thirdOnboardingView, fourthOnboardingView, fifthOnboardingView].forEach {
            pageScrollView.addSubview($0)
        }
    }
    
    override func setupBinding() {

    }
    
    override func layout() {
        pageScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.height.equalTo(view.frame.height)
            $0.width.equalTo(view.frame.width * CGFloat(pageScrollView.subviews.count-1))
            $0.edges.equalToSuperview()
        }
        
        firstOnboardingView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(1.25)
            $0.width.equalTo(view.frame.width)
        }
        
        secondOnboardingView.snp.makeConstraints {
            $0.leading.equalTo(firstOnboardingView.snp.trailing)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(64)
            $0.width.equalTo(view.frame.width)
        }
        
        thirdOnboardingView.snp.makeConstraints {
            $0.leading.equalTo(secondOnboardingView.snp.trailing)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(64)
            $0.width.equalTo(view.frame.width)
        }
        
        fourthOnboardingView.snp.makeConstraints {
            $0.leading.equalTo(thirdOnboardingView.snp.trailing)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(64)
            $0.width.equalTo(view.frame.width)
        }
        
        fifthOnboardingView.snp.makeConstraints {
            $0.leading.equalTo(fourthOnboardingView.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(64)
            $0.width.equalTo(view.frame.width)
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-26)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}

extension ManualViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        self.pageControl.currentPage = Int(round(offsetX/self.view.frame.width))
    }
}
