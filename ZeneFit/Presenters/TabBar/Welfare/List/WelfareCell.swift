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
    func toggleCalendarStatus(policy: PolicyInfoDTO, completion: (()->Void)?)
    func tapApplyWelfare(policy: PolicyInfoDTO)
    func tapApplyWelfareFlag(policy: PolicyInfoDTO, completion: (()->Void)?)
}

final class WelfareCell: UITableViewCell {
    
    private var cancellable = Set<AnyCancellable>()
    weak var delegate: WelfareDelegate?
    private var policy: PolicyInfoDTO?
    
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
    
    private let selectButton = UIButton().then {
        $0.isSkeletonable = true
        $0.skeletonCornerRadius = 8
        $0.setImage(.init(named: "Check-Off_welfare")?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.setImage(.init(named: "Check-On_welfare")?.withRenderingMode(.alwaysOriginal), for: .selected)
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
        $0.setImage(.init(named: "Add-schedule")?.withRenderingMode(.alwaysOriginal), for: .disabled)
    }
    
    private let applyButton = UIButton(type: .custom).then {
        var configure = UIButton.Configuration.filled()
        configure.background.cornerRadius = 8
        configure.baseForegroundColor = .primaryNormal
        configure.baseBackgroundColor = .primaryAssistive
        configure.attributedTitle = .init("월 n만원 신청하기",
                                          attributes: .init([.font : UIFont.pretendard(.label4)]))
        
        $0.configurationUpdateHandler = {
            switch $0.state {
            case .disabled:
                $0.configuration?.attributedTitle = .init(
                    "이미 신청한 정책입니다.",
                    attributes:.init( [.font : UIFont.pretendard(.label4),
                                       .foregroundColor: UIColor.white])
                )
            default:
                $0.configuration?.attributedTitle?.font = UIFont.pretendard(.label4)
                $0.configuration?.attributedTitle?.foregroundColor = UIColor.primaryNormal
                break
            }
        }
        
        $0.configuration = configure
        $0.isSkeletonable = true
        $0.skeletonCornerRadius = 8
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .lineNormal
    }
    
    override var isSelected: Bool {
        didSet {
            guard let policy else { return }
            
            if let _ = policy.policyApplyDenialReason {
                applyButton.isEnabled = false
                selectButton.isEnabled = false
                applyButton.configuration?.attributedTitle = .init(
                    "신청할 수 없어요",
                    attributes: .init([.font : UIFont.pretendard(.label4),
                                       .foregroundColor : UIColor.white])
                )
                return
            } else {
                applyButton.isEnabled = true
                selectButton.isEnabled = true
            }
            
            let title = policy.benefit == 0 ? "신청하기" : "월 \(policy.benefit ?? 0/10000)만원 신청하기"
            
            if isSelected {
                self.applyButton.configuration?.attributedTitle = .init(
                    "이미 신청한 정책입니다.",
                    attributes: .init([.font : UIFont.pretendard(.label4),
                                       .foregroundColor : UIColor.white])
                )
            } else {
                self.applyButton.configuration?.attributedTitle = .init(
                    title,
                    attributes: .init([.font : UIFont.pretendard(.label4),
                                       .foregroundColor : UIColor.primaryNormal])
                )
            }
            
            self.addScheduleButton.isEnabled = !isSelected
            self.applyButton.isEnabled = !isSelected
            self.applyButton.configuration?.baseForegroundColor = isSelected ? .white : .primaryNormal
            self.selectButton.isSelected = isSelected
            self.policyLabel.textColor = isSelected ? .textDisable : .textNormal
            self.agencyLabel.textColor = isSelected ? .textDisable : .textAlternative
            self.contentLabel.textColor = isSelected ? .textDisable : .textNormal
            
            configureDateType(type: PolicyDateType(rawValue: policy.policyDateType) ?? .blank)
            configureMethodType(type: PolicyMethodType(rawValue: policy.policyMethodType) ?? .blank)
        }
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
    }
    
    // selectButton에 따라 분기해줘야함
    func configureCell(item: PolicyInfoDTO) {
        self.isHidden = false
        self.policy = item
        self.policyImageView.kf.setImage(with: URL(string: item.policyLogo ?? ""),
                                         placeholder: UIImage(named: "DefaultPolicy"))
    
        self.setSelected(item.applyFlag, animated: false)
        
        self.configureDateType(type: PolicyDateType(rawValue: item.policyDateType) ?? .blank)
        self.configureMethodType(type: PolicyMethodType(rawValue: item.policyMethodType) ?? .blank)
        
        self.policyLabel.text = item.policyName
        self.contentLabel.text = item.policyIntroduction
        
        self.addScheduleButton.isSelected = item.interestFlag
    }
    
    private func configureDateType(type: PolicyDateType) {
        let textColor: UIColor = self.isSelected ? .textDisable : .secondaryNormal
        let borderColor: UIColor = self.isSelected ? .lineAlternative : .secondaryAssistive
        
        dateTypeLabel.text = type.description
        dateTypeLabel.isHidden = type == .blank || type == .undecided
        dateTypeLabel.textColor = textColor
        dateTypeLabel.layer.borderColor = borderColor.cgColor
    }
    
    private func configureMethodType(type: PolicyMethodType) {
        let textColor: UIColor = self.isSelected ? .textDisable : .primaryNormal
        let borderColor: UIColor = self.isSelected ? .lineAlternative : .primaryAssistive
        
        methodTypeLabel.text = type.description
        methodTypeLabel.isHidden = type == .blank
        methodTypeLabel.textColor = textColor
        methodTypeLabel.layer.borderColor = borderColor.cgColor
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
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview()
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
            .receive(on: RunLoop.main)
//            .debounce(for: .seconds(0.4), scheduler: DispatchQueue.main)
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
            .sink { [weak self] in
                guard let self,
                      let policy else { return }
                self.delegate?.toggleCalendarStatus(policy: policy) {
                    self.addScheduleButton.isSelected.toggle()
                }
            }.store(in: &cancellable)
        
        applyButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self,
                      let policy else { return }
                self.delegate?.tapApplyWelfare(policy: policy)
            }.store(in: &cancellable)
        
        selectButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self,
                      let policy else { return }
                
                self.delegate?.tapApplyWelfareFlag(policy: policy) {
                    self.isSelected = policy.applyFlag
                }
            }.store(in: &cancellable)
    }
    
    private func setGesture() {
    }
}
