//
//  WelfareCell.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/09.
//

import UIKit
import Combine
import Kingfisher
import SkeletonView

protocol WelfareDelegate: AnyObject {
    func toggleCalendarStatus()
    func tapApplyWelfare()
}

final class WelfareCell: UITableViewCell {
    
    private var cancellable = Set<AnyCancellable>()
    weak var delegate: WelfareDelegate?
    
    var titleTapHandler: (()->Void)?
    
    private let frameView = UIView().then {
        $0.backgroundColor = .white
        $0.isSkeletonable = true
    }
    
    private let policyImageView = UIImageView().then {
        $0.isSkeletonable = true
        $0.layer.cornerRadius = 22
        $0.clipsToBounds = true
        $0.image = .init(named: "DefaultPolicy")
    }
    
    private let agencyLabel = UILabel().then {
        $0.isSkeletonable = true
        $0.linesCornerRadius = 4
        $0.text = "기관"
        $0.textColor = .textAlternative
        $0.font = .pretendard(.chips)
    }
    
    private let policyLabel = UILabel().then {
        $0.isSkeletonable = true
        $0.linesCornerRadius = 4
        $0.text = "정책 이름"
        $0.font = .pretendard(.label2)
        $0.textColor = .textNormal
    }
    
    private let selectButton = UIButton(type: .system).then {
        $0.isSkeletonable = true
        $0.skeletonCornerRadius = 8
        $0.setImage(.init(named: "Check-Off_welfare")?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.setImage(.init(named: "Check-On_welfare")?.withRenderingMode(.alwaysOriginal), for: .selected)
    }
    
    private let applyTypeStackView = UIStackView().then {
        $0.isSkeletonable = true
        $0.distribution = . fill
        $0.spacing = 4
    }
    
    private let contentLabel = UILabel().then {
        $0.isSkeletonable = true
        $0.linesCornerRadius = 4
        $0.text = "정책 정보입니다. 정책 정보는 대략 2-3줄로 구성할 예정입니다. 정책 정보입니다. 정책 정보는 대략 2-3줄로 구성할 예정입니다. 정책 정보는 대략 2-3줄로 구성할 예정입니다."
        $0.textColor = .textNormal
        $0.font = .pretendard(.body2)
        $0.numberOfLines = 3
    }
    
    private let addScheduleButton = UIButton().then {
        $0.isSkeletonable = true
        $0.skeletonCornerRadius = 8
        $0.setImage(.init(named: "Add-scheduleOff")?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.setImage(.init(named: "Add-scheduleOn")?.withRenderingMode(.alwaysOriginal), for: .selected)
    }
    
    private let applyButton = UIButton().then {
        var configure = UIButton.Configuration.filled()
        configure.background.cornerRadius = 8
        configure.baseForegroundColor = .primaryNormal
        configure.baseBackgroundColor = .primaryAssistive
        configure.attributedTitle = .init("월 n만원 신청하기",
                                          attributes: .init([.font : UIFont.pretendard(.label4)]))
        
        $0.configuration = configure
        $0.isSkeletonable = true
        $0.skeletonCornerRadius = 8
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .lineNormal
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        applyTypeStackView.arrangedSubviews
            .forEach {
                $0.removeFromSuperview()
            }
        selectButton.setImage(nil, for: .normal)
        addScheduleButton.setImage(nil, for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        isSkeletonable = true
        
        addSubViews()
        setLayout()
        setupBinding()
        setGesture()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureApplyType(types: [String]) {
        
        applyTypeStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        types.forEach { type in
            let textColor: UIColor = type == "기간신청" ? .secondaryNormal : .primaryNormal
            let borderColor: UIColor = type == "기간신청" ? .secondaryAssistive : .primaryAssistive
            
            let label = PaddingLabel(padding: .init(top: 8, left: 8, bottom: 8, right: 8)).then {
                $0.isSkeletonable = true
                $0.clipsToBounds = true
                $0.text = type
                $0.font = .pretendard(.chips)
                $0.textColor = textColor
                $0.layer.cornerRadius = 14
                $0.layer.borderColor = borderColor.cgColor
                $0.layer.borderWidth = 1
            }
            
            
            _ = UIView(frame: label.frame).then {
                $0.isSkeletonable = true
                
                label.addSubview($0)
                
                $0.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
            }
            
            applyTypeStackView.addArrangedSubview(label)
        }
    
    }
    
    func configureCell(item: PolicyInfoDTO) {
        self.policyImageView.kf.setImage(with: URL(string: item.policyLogo),
                                         placeholder: UIImage(named: "DefaultPolicy"))
        self.policyLabel.text = item.policyName
        self.contentLabel.text = item.policyIntroduction
        self.applyButton.configuration?.attributedTitle = .init("월 \(item.benefit/10000)만원 신청하기",
                                                                attributes: .init([.font : UIFont.pretendard(.label4)]))
        self.selectButton.isSelected = item.applyFlag
        self.addScheduleButton.isSelected = item.interestFlag
        
        configureApplyType(types: [item.policyDateTypeDescription])
    }

    private func addSubViews() {
        contentView.addSubview(frameView)
        
        [policyImageView, agencyLabel, policyLabel, applyTypeStackView, selectButton, contentLabel, addScheduleButton, applyButton, separatorView].forEach {
            frameView.addSubview($0)
        }
    }
    
    private func setLayout() {
        frameView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        policyImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(16)
            $0.size.equalTo(44)
        }
        
        agencyLabel.snp.makeConstraints {
            $0.leading.equalTo(policyImageView.snp.trailing).offset(16)
            $0.top.equalToSuperview().offset(16)
        }
        
        policyLabel.snp.makeConstraints {
            $0.leading.equalTo(policyImageView.snp.trailing).offset(16)
            $0.trailing.equalTo(selectButton.snp.leading).offset(-16)
            $0.top.equalTo(agencyLabel.snp.bottom).offset(4)
        }
        
        selectButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(policyImageView)
            $0.size.equalTo(32)
        }
        
        applyTypeStackView.snp.makeConstraints {
            $0.top.equalTo(policyLabel.snp.bottom).offset(4)
            $0.leading.equalTo(policyImageView.snp.trailing).offset(16)
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(policyImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview()
            $0.top.equalTo(applyTypeStackView.snp.bottom).offset(8)
        }
        
        applyButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(36)
            $0.top.equalTo(contentLabel.snp.bottom).offset(8)
        }
        
        addScheduleButton.snp.makeConstraints {
            $0.height.width.equalTo(36)
            $0.centerY.equalTo(applyButton)
            $0.trailing.equalTo(applyButton.snp.leading).offset(-8)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(applyButton.snp.bottom).offset(16)
            $0.bottom.equalToSuperview()
        }
    }

    private func setupBinding() {
        addScheduleButton.tapPublisher
            .sink { [weak self] in
                self?.delegate?.toggleCalendarStatus()
                self?.addScheduleButton.isSelected.toggle()
            }.store(in: &cancellable)
        
        applyButton.tapPublisher
            .sink { [weak self] in
                self?.delegate?.tapApplyWelfare()
            }.store(in: &cancellable)
    }
    
    private func setGesture() {
    }
}
