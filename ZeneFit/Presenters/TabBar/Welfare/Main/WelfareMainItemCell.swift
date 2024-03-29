//
//  WelFareCategoryCell.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/05.
//

import UIKit
import Combine

protocol WelfareMainItemCellDelegate: AnyObject {
    func tapTopFrame(type: SupportPolicyType) -> Void
}

final class WelfareMainItemCell: UITableViewCell {
    private var policy: PolicyMainInfo?
    weak var delegate: WelfareMainItemCellDelegate?
    
    private var cancellable = Set<AnyCancellable>()

    private let totalFrameView = UIStackView().then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .white
    }
    
    private let topFrameView = UIStackView()
    
    private let titleLabel = UILabel().then {
        $0.text = "정책명"
        $0.font = .pretendard(.label2)
        $0.textColor = .textStrong
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .lineAlternative
    }
    
    private let countLabel = PaddingLabel(vPadding: 0, hPadding: 6).then {
        $0.textAlignment = .center
        $0.clipsToBounds = true
        $0.text = "0"
        $0.layer.cornerRadius = 10
        $0.textColor = .white
        $0.font = .pretendard(.label5)
        $0.backgroundColor = .primaryNormal
    }
    
    private let policyImageView = UIImageView().then {
        $0.layer.cornerRadius = 22
        $0.clipsToBounds = true
        $0.image = .init(named: "DefaultPolicy")
    }
    
    private let agencyLabel = UILabel().then {
        $0.text = "기관"
        $0.textColor = .textAlternative
        $0.font = .pretendard(.chips)
    }
    
    private let policyLabel = UILabel().then {
        $0.text = "정책 이름"
        $0.font = .pretendard(.label2)
        $0.textColor = .textNormal
    }
    
    private lazy var applyTypeStackView = UIStackView(arrangedSubviews: [dateTypeLabel, methodTypeLabel]).then {
        $0.isSkeletonable = true
        $0.distribution = . fill
        $0.spacing = 4
    }
    
    private let dateTypeLabel =  PaddingLabel(vPadding: 4, hPadding: 8).then {
        $0.isSkeletonable = true
        $0.clipsToBounds = true
        $0.font = .pretendard(.chips)
        $0.textColor = .secondaryNormal
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.secondaryAssistive.cgColor
    }
    
    private let methodTypeLabel = PaddingLabel(vPadding: 4, hPadding: 8).then {
        $0.isSkeletonable = true
        $0.clipsToBounds = true
        $0.font = .pretendard(.chips)
        $0.textColor = .primaryNormal
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.primaryAssistive.cgColor
    }
    
    private let contentLabel = UILabel().then {
        $0.text = "정책 정보입니다. 정책 정보는 대략 2-3줄로 구성할 예정입니다. 정책 정보입니다. 정책 정보는 대략 2-3줄로 구성할 예정입니다. 정책 정보는 대략 2-3줄로 구성할 예정입니다."
        $0.textColor = .textNormal
        $0.font = .pretendard(.body2)
        $0.numberOfLines = 3
    }
    
    private let disclosureImage = UIImageView().then {
        $0.image = .init(named: "i-nex-26")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .backgroundPrimary
        
        addSubViews()
        setLayout()
        setupBinding()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func resetItem() {
        applyTypeStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    func configureCell(item: PolicyMainInfo) {
        policy = item
        titleLabel.text = SupportPolicyType(rawValue: item.supportType)?.description
        var count = "\(item.supportTypePolicyCnt)"
        if count.count > 2 { count += "+" }
        countLabel.text = count
        policyImageView.kf.setImage(with: URL(string: item.policyLogo ?? ""),
                                    placeholder: UIImage(named: "DefaultPolicy"))
        agencyLabel.text = item.policyCityCode
        policyLabel.text = item.policyName
        contentLabel.text = item.policyIntroduction
        
        self.configureDateType(type: PolicyDateType(rawValue: item.policyDateType) ?? .blank)
        self.configureMethodType(type: PolicyMethodType(rawValue: item.policyMethodType) ?? .blank)
    }
    
    private func configureDateType(type: PolicyDateType) {
        let textColor: UIColor = self.isSelected ? .textDisable : .secondaryNormal
        let borderColor: UIColor = self.isSelected ? .lineDisable : .secondaryAssistive
        
        dateTypeLabel.text = type.description
        dateTypeLabel.isHidden = type == .blank || type == .undecided
        dateTypeLabel.textColor = textColor
        dateTypeLabel.layer.borderColor = borderColor.cgColor
    }
    
    private func configureMethodType(type: PolicyMethodType) {
        let textColor: UIColor = self.isSelected ? .textDisable : .primaryNormal
        let borderColor: UIColor = self.isSelected ? .lineDisable : .primaryAssistive
        
        methodTypeLabel.text = type.description
        methodTypeLabel.isHidden = type == .blank
        methodTypeLabel.textColor = textColor
        methodTypeLabel.layer.borderColor = borderColor.cgColor
    }

    private func addSubViews() {
        contentView.addSubview(totalFrameView)
        
        [topFrameView, separatorView, policyImageView, agencyLabel, policyLabel, applyTypeStackView, contentLabel].forEach {
            totalFrameView.addSubview($0)
        }
        
        [titleLabel, countLabel, disclosureImage].forEach {
            topFrameView.addSubview($0)
        }
    }
    
    private func setLayout() {
        totalFrameView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        topFrameView.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
            $0.top.equalTo(topFrameView.snp.bottom)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview().inset(16)
        }
        
        disclosureImage.snp.makeConstraints {
            $0.width.height.equalTo(28)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.trailing.equalTo(disclosureImage.snp.leading)
            $0.centerY.equalTo(disclosureImage)
        }
        
        policyImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(separatorView.snp.bottom).offset(16)
            $0.width.height.equalTo(44)
        }
        
        agencyLabel.snp.makeConstraints {
            $0.leading.equalTo(policyImageView.snp.trailing).offset(16)
            $0.top.equalTo(policyImageView)
        }
        
        policyLabel.snp.makeConstraints {
            $0.leading.equalTo(agencyLabel)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(agencyLabel.snp.bottom).offset(4)
        }
        
        applyTypeStackView.snp.makeConstraints {
            $0.top.equalTo(policyLabel.snp.bottom).offset(4)
            $0.leading.equalTo(agencyLabel)
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(agencyLabel)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(applyTypeStackView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-24)
        }
    }

    private func setupBinding() {
        topFrameView.gesturePublisher(for: .tap)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let policy = self?.policy else { return }
                let type = SupportPolicyType(rawValue: policy.supportType) ?? .money
                self?.delegate?.tapTopFrame(type: type)
                
            }.store(in: &cancellable)
    }
}
