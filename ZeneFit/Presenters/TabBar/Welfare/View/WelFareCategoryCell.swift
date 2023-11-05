//
//  WelFareCategoryCell.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/05.
//

import UIKit
import Combine

final class WelFareCategoryCell: UITableViewCell {
    static let identifier = "WelFareCategoryCell"
    
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
    
    private let countLabel = UILabel().then {
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
    
    private let applyTypeStackView = UIStackView().then {
        $0.spacing = 4
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
    
    private let addScheduleButton = UIButton(type: .system).then {
        $0.setImage(.init(named: "Add-scheduleOff")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private let applyButton = UIButton().then {
        $0.layer.cornerRadius = 8
        $0.setTitle("월n만원 신청하기", for: .normal)
        $0.setTitleColor(.primaryNormal, for: .normal)
        $0.titleLabel?.font = .pretendard(.label4)
        $0.backgroundColor = .primaryAssistive
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .backgroundPrimary
        
        addSubViews()
        setLayout()
        setupBinding()
        setGesture()
        
        configureApplyType(types: ["상시신청","방문신청"])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureApplyType(types: [String]) {
        types.forEach { type in
            let label = PaddingLabel(padding: .init(top: 8, left: 8, bottom: 8, right: 8)).then {
                $0.clipsToBounds = true
                $0.text = type
                $0.font = .pretendard(.chips)
                $0.textColor = .textAlternative
                $0.layer.cornerRadius = 14
                $0.layer.borderColor = UIColor.lineNormal.cgColor
                $0.layer.borderWidth = 1
            }
            
            applyTypeStackView.addArrangedSubview(label)
        }
        
    }

    private func addSubViews() {
        contentView.addSubview(totalFrameView)
        
        [topFrameView, separatorView, policyImageView, agencyLabel, policyLabel, applyTypeStackView, contentLabel, addScheduleButton, applyButton].forEach {
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
            $0.width.height.equalTo(20)
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
            $0.top.equalTo(agencyLabel.snp.bottom).offset(4)
        }
        
        applyTypeStackView.snp.makeConstraints {
            $0.top.equalTo(policyLabel.snp.bottom).offset(4)
            $0.leading.equalTo(agencyLabel)
            $0.height.equalTo(26)
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(agencyLabel)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(applyTypeStackView.snp.bottom).offset(8)
        }
        
        applyButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(36)
            $0.width.equalTo(124)
            $0.top.equalTo(contentLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        addScheduleButton.snp.makeConstraints {
            $0.height.width.equalTo(36)
            $0.centerY.equalTo(applyButton)
            $0.trailing.equalTo(applyButton.snp.leading).offset(-8)
        }
    }

    private func setupBinding() {
        
    }
    
    private func setGesture() {
        topFrameView.gesture(for: .tap)
            .sink { [weak self] _ in
                print(#function)
            }.store(in: &cancellable)
    }
    
}
