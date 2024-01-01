//
//  FindWelfareViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import UIKit
import Lottie

final class FindWelfareViewController: BaseViewController {
    weak var coordinator: WelfareCoordinator?
    private let viewModel: FindWelfareViewModel
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .textStrong
        $0.text = "당신만을 위한\n복지정책을 찾고 있어요..."
        $0.font = .pretendard(.label1)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.textColor = .textAlternative
        $0.font = .pretendard(.body1)
        $0.text = "금방 찾아드릴게요!"
    }
    
    init(viewModel: FindWelfareViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        self.navigationItem.leftBarButtonItem = nil
    }
    
    override func setupBinding() {
        viewModel.findResult
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] result in
                guard let self else { return }
                let resultType: FindWelfareResultType = result.policyCnt > 0 ? .success : .fail
                coordinator?.setAction(.findResult(viewModel: viewModel,
                                                   resultType: resultType))
            }.store(in: &cancellable)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.findWelfareList()
        giftAnimationView.play()
    }
    
    private let giftAnimationView = LottieAnimationView(asset: "gift").then {
        $0.loopMode = .loop
    }
    
    override func addSubView() {
        [titleLabel, subTitleLabel, giftAnimationView].forEach {
            view.addSubview($0)
        }
    }
    
    override func layout() {
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
        }
        
        giftAnimationView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(60)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(giftAnimationView.snp.width)
        }
    }
}
