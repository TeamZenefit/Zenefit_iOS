//
//  FindWelfareResultViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import UIKit

enum FindWelfareResultType {
    case success
    case fail
}

final class FindWelfareResultViewController: BaseViewController {
    private let viewModel: FindWelfareViewModel
    private let resultType: FindWelfareResultType
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .textStrong
        $0.font = .pretendard(.title1)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .textAlternative
        $0.font = .pretendard(.body1)
    }
    
    private let giftImageView = UIImageView()
    
    private let completeButton = BottomButton().then {
        $0.titleLabel?.font = .pretendard(.label3)
        $0.layer.cornerRadius = 8
        
    }
    
    init(viewModel: FindWelfareViewModel,
         resultType: FindWelfareResultType) {
        self.viewModel = viewModel
        self.resultType = resultType
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(resultType: resultType)
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        self.navigationItem.leftBarButtonItem = nil
    }
    
    override func setupBinding() {
        completeButton.tapPublisher
            .sink { [weak self] in
                guard let self else { return }
                switch resultType {
                case .success:
                    navigationController?.popToRootViewController(animated: false)
                case .fail:
                    navigationController?.popToRootViewController(animated: false)
                }
            }.store(in: &cancellable)
    }
    
    override func addSubView() {
        [titleLabel, subTitleLabel, giftImageView, completeButton].forEach {
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
        
        giftImageView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(60)
            $0.horizontalEdges.equalToSuperview().inset(28)
            $0.height.equalTo(giftImageView.snp.width)
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(additionalSafeAreaInsets.bottom).inset(40)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
    }
    
    private func configureUI(resultType: FindWelfareResultType) {
        var title: String = "\(viewModel.findResult.nickname)님이 신청할 수 있는\n"
        let subTitle: String
        let completionTitle: String
        let completionBGColor: UIColor
        let completionTitleColor: UIColor
        let giftImage: UIImage?
        
        switch resultType {
        case .success:
            giftImage = UIImage(named: "SuccessGift")
            completionTitleColor = .primaryNormal
            completionBGColor = .primaryAssistive
            completionTitle = "모든 정책 볼래요"
            title += "정책을 \(viewModel.findResult.policyCnt)가지 찾았어요!"
            subTitle = "닉네임이 받을 수 있는 금액도\n모두 계산이 끝났어요"
        case .fail:
            giftImage = UIImage(named: "FailGift")
            completionTitleColor = .white
            completionBGColor = .primaryNormal
            completionTitle = "다시 찾아보기"
            title += "정책을 못찾았어요.."
            subTitle = "조건을 다시 설정하고 신청해보세요..."
        }
        
        giftImageView.image = giftImage?.withRenderingMode(.alwaysOriginal)
        completeButton.backgroundColor = completionBGColor
        completeButton.setTitleColor(completionTitleColor, for: .normal)
        completeButton.setTitle(completionTitle, for: .normal)
        completeButton.titleLabel?.font = .pretendard(.label3)
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
}
