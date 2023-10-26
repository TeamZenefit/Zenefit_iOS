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
        $0.numberOfPages = 4
        $0.tintColor = .purple
        $0.currentPage = 0
        $0.pageIndicatorTintColor = .fillDisable
        $0.currentPageIndicatorTintColor = .primaryNormal
        $0.hidesForSinglePage = true
    }
    
    private let firstOnboardingView = UIImageView(image: UIImage(named: "ManualOne")?.withRenderingMode(.alwaysOriginal))
    
    private let secondOnboardingView = UIImageView(image: UIImage(named: "ManualTwo")?.withRenderingMode(.alwaysOriginal))
    
    private let thirdOnboardingView = UIImageView(image: UIImage(named: "ManualThree")?.withRenderingMode(.alwaysOriginal))
    
    private let fourthOnboardingView = UIImageView(image: UIImage(named: "ManualFour")?.withRenderingMode(.alwaysOriginal))
    
    private let fifthOnboardingView = UIImageView(image: UIImage(named: "ManualFive")?.withRenderingMode(.alwaysOriginal))
    
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
    }
    
    override func addSubView() {
        [pageScrollView, pageControl, closeButton].forEach {
            view.addSubview($0)
        }
        
        [firstOnboardingView, secondOnboardingView, thirdOnboardingView, fourthOnboardingView, fifthOnboardingView].forEach {
            pageScrollView.addSubview($0)
        }
    }
    
    override func setupBinding() {

    }
    
    override func layout() {
        pageScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        firstOnboardingView.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview()
            $0.height.equalTo(view.frame.height)
            $0.width.equalTo(view.frame.width)
        }
        
        secondOnboardingView.snp.makeConstraints {
            $0.leading.equalTo(firstOnboardingView.snp.trailing)
            $0.verticalEdges.equalToSuperview()
            $0.width.equalTo(view.frame.width)
        }
        
        thirdOnboardingView.snp.makeConstraints {
            $0.leading.equalTo(secondOnboardingView.snp.trailing)
            $0.verticalEdges.equalToSuperview()
            $0.width.equalTo(view.frame.width)
        }
        
        fourthOnboardingView.snp.makeConstraints {
            $0.leading.equalTo(thirdOnboardingView.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
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