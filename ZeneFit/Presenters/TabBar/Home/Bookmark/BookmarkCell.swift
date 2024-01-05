//
//  BookmarkCell.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/31.
//

import UIKit

final class BookmarkCell: UITableViewCell {	
    var deleteButtonTapped: ((Int)->Void)?
    
    private let frameView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }
    
    private let thumbnailImageView = UIImageView(image: .init(named: "DefaultPolicy")).then {
        $0.layer.cornerRadius = 13
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "정책 이름"
        $0.font = .pretendard(.label2)
        $0.textColor = .textNormal
    }
    
    private let contentLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.text = "정책 정보입니다. 정책 정보는 대략 2줄로 구성할 예정입니다. 정책 정보입니다. 정책 정보는 대략 2줄로 구성"
        $0.font = .pretendard(.body2)
        $0.textColor = .textNormal
    }
    
    private let dateLabel = PaddingLabel(padding: .init(top: 6, left: 10, bottom: 6, right: 10)).then {
        $0.text = "00/00 까지"
        $0.layer.masksToBounds = true
        $0.font = .pretendard(.label5)
        $0.layer.cornerRadius = 14
        $0.textColor = .primaryNormal
        $0.backgroundColor = .primaryAssistive
    }
    
    private let deleteButton = UIButton().then {
        var configuration = UIButton.Configuration.filled()
        configuration.background.cornerRadius = 13
        configuration.contentInsets = .init(top: 6, leading: 10, bottom: 6, trailing: 10)
        configuration.baseBackgroundColor = .alert
        configuration.attributedTitle = .init("삭제하기", attributes: .init([.font : UIFont.pretendard(.label5),
                                                                         .foregroundColor : UIColor.white]))
        $0.configuration = configuration
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .backgroundPrimary
        selectionStyle = .none
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(policyItem: BookmarkPolicy, isEditMode: Bool) {
        deleteButton.isHidden = !isEditMode
        dateLabel.isHidden = policyItem.applyEndDate == nil || isEditMode
        
        thumbnailImageView.kf.setImage(with: URL(string: policyItem.policyLogo),
                                       placeholder: UIImage(named: "DefaultPolicy"))
        titleLabel.text = policyItem.policyName
        contentLabel.text = policyItem.policyIntroduction
        dateLabel.text = policyItem.applyEndDate
        
        deleteButton.addAction(
            .init(handler: { [weak self] _ in
            self?.deleteButtonTapped?(policyItem.policyID)
        }), for: .touchUpInside)
    }
    
    private func setLayout() {
        contentView.addSubview(frameView)
        [thumbnailImageView, titleLabel, contentLabel, dateLabel, deleteButton].forEach {
            frameView.addSubview($0)
        }
        
        frameView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview().inset(16)
            $0.top.equalToSuperview()
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(16)
            $0.width.height.equalTo(26)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(thumbnailImageView)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(dateLabel.snp.leading).offset(-16)
        }
        
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        dateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(titleLabel)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel)
            $0.bottom.trailing.equalToSuperview().offset(-16)
        }
        
        deleteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(titleLabel)
        }
    }
}
