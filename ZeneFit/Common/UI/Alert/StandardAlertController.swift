//
//  StandardAlertController.swift
//  OnandOff
//
//  Created by 신상우 on 2023/02/18.
//

import UIKit

final class StandardAlertController: UIViewController{
    private lazy var alertView = UIStackView().then {
        $0.axis = .vertical
        $0.layer.masksToBounds = true
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lineNormal.cgColor
        $0.layer.cornerRadius = 16
    }
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .pretendard(.label3)
        $0.numberOfLines = 0
        $0.textColor = .textStrong
    }
    
    private let messageLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .pretendard(.label5)
        $0.numberOfLines = 0
        $0.textColor = .textAlternative
    }
    
    private lazy var contentStackView = UIStackView(arrangedSubviews: [titleLabel, messageLabel]).then {
        $0.spacing = 4
        $0.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
    }
    
    private let actionStackView = UIStackView().then {
        $0.distribution = .fillProportionally
        $0.spacing = 8
    }
    
    init(title: String?, message: String?) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
        
        self.titleLabel.text = title
        self.messageLabel.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubView()
        self.layout()
        self.configure()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Configure
    private func configure() {
        self.view.backgroundColor = .black.withAlphaComponent(0.1)
        NotificationCenter.default.addObserver(self, selector: #selector(willDismissVC), name: .dismissStandardAlert, object: nil)
    }
    
    func addAction(_ action: UIButton...) {
        action.forEach {
            self.actionStackView.addArrangedSubview($0)
        }
    }
    
    /// 알림 제목 부분 색 변환 ( 하이라이트) 함수
    func titleHighlight(highlightString: String, color: UIColor) {
        guard let oldAttributeStr = self.titleLabel.attributedText else { return }
        let newAttributeStr = NSMutableAttributedString(attributedString: oldAttributeStr)
        newAttributeStr.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: ((self.titleLabel.text ?? "") as NSString).range(of: highlightString))
        
        self.titleLabel.attributedText = newAttributeStr
    }
    
    /// 알림 메시지 부분 색 변환 ( 하이라이트) 함수
    func messageHighlight(highlightString: String, color: UIColor) {
        guard let oldAttributeStr = self.messageLabel.attributedText else { return }
        let newAttributeStr = NSMutableAttributedString(attributedString: oldAttributeStr)
        newAttributeStr.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: ((self.messageLabel.text ?? "") as NSString).range(of: highlightString))
        
        self.messageLabel.attributedText = newAttributeStr
    }
    
    // MARK: - AddSubView
    private func addSubView() {
        self.view.addSubview(self.alertView)
        
        self.alertView.addSubview(contentStackView)
        self.alertView.addSubview(actionStackView)
    }
    
    // MARK: - Layout
    private func layout() {
        self.alertView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(47)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        self.actionStackView.snp.makeConstraints {
            $0.top.equalTo(contentStackView.snp.bottom).offset(20)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().offset(-20)
            $0.centerX.equalToSuperview()
        }
    }
    
    //MARK: - Selector
    @objc private func willDismissVC() {
        self.dismiss(animated: false)
    }
}
