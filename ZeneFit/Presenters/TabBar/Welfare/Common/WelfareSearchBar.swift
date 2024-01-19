//
//  WelfareSearchBar.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/09.
//

import UIKit
import Combine

final class WelfareSearchBar: UISearchBar {
    private var cancellable = Set<AnyCancellable>()
    
    let searchButton = UIButton(type: .system).then {
        $0.setImage(.init(named: "i-sear-24")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.backgroundColor = .fillNormal
        self.searchTextField.leftView = nil
        self.backgroundImage = UIImage()
        self.searchTextField.backgroundColor = .clear
        self.searchTextField.rightViewMode = .never
        self.searchTextField.clearButtonMode = .never
        self.searchTextField.textColor = .textNormal
        self.searchTextField.autocorrectionType = .no
        self.searchTextField.spellCheckingType = .no
        addSubview(searchButton)

        searchTextField.delegate = self
        
        searchButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        searchButton.addAction(.init(handler: { [weak self] _ in
            self?.endEditing(false)
        }), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WelfareSearchBar: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(false)
        return true
    }
}
