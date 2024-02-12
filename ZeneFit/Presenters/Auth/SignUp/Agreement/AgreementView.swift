//
//  AgreementView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/04.
//

import UIKit
import Combine

final class AgreementView: UIView {
    //MARK: - Properties
    private var cancellable = Set<AnyCancellable>()
    private let agreementTypeString: String
    var tapHandler: (()->Void)?
    
    let checkButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "che-box-off")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }

    private let contentLabel = BaseLabel().then {
        $0.font = .pretendard(.body1)
        $0.textColor = .textNormal
    }
    
    let disclosureButton = UIButton(type: .system).then {
        $0.semanticContentAttribute = .forceRightToLeft
        $0.titleLabel?.font = .pretendard(.chips)
        $0.setTitleColor(.textAssistive, for: .normal)
        $0.setTitle("약관 보기", for: .normal)
        $0.setImage(UIImage(named: "i-nex-24")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    var disclouserIsHidden: Bool = false {
        didSet {
            disclosureButton.isHidden = disclouserIsHidden
        }
    }
    
    @Published var isAgree: Bool = false
    
    //MARK: - Init
    init(_ content: String, isRequired: Bool, isHighlight: Bool = false, tapHanlder: (()->Void)? = nil) {
        self.agreementTypeString = isRequired ? "" : " (선택)"
        self.tapHandler = tapHanlder
        super.init(frame: .zero)
        self.contentLabel.text = content + agreementTypeString
        
        if isHighlight {
            contentLabel.font = .pretendard(.label3)
        }
        
        self.addSubView()
        self.layout()
        self.setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBinding() {
        $isAgree
            .sink { [weak self] isAgree in
                let image: UIImage? = isAgree ? UIImage(named: "che-box-on") : UIImage(named: "che-box-off")
                self?.checkButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            .store(in: &cancellable)
        
        disclosureButton.tapPublisher
            .sink { [weak self] _ in
                self?.tapHandler?()
            }.store(in: &cancellable)
    }
    
    //MARK: - AddSubView
    private func addSubView() {
        [checkButton, contentLabel, disclosureButton].forEach {
           addSubview($0)
        }
    }
    
    //MARK: - Layout
    private func layout() {
        self.checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        
        self.contentLabel.snp.makeConstraints {
            $0.leading.equalTo(self.checkButton.snp.trailing).offset(10)
            $0.verticalEdges.equalToSuperview().inset(8)
        }
        
        self.disclosureButton.snp.makeConstraints {
            $0.trailing.verticalEdges.equalToSuperview()
        }
    }
}
