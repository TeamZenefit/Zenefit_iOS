//
//  WelfareSortButton.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/09.
//

import UIKit
import Combine

final class WelfareSortButton: UIButton {
    private var cancellable = Set<AnyCancellable>()
    @Published var isOpen: Bool = false
    
    var title: String = "수혜정책" {
        didSet {
            self.configuration?.attributedTitle = .init(title,
                                                        attributes: .init([.font : UIFont.pretendard(.body2),
                                                                           .foregroundColor : UIColor.textNormal]))
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        
        var configure = UIButton.Configuration.filled()
        configure.baseBackgroundColor = .fillNormal
        configure.image = .init(named: "i-op-20")
        configure.imagePadding = 8
        configure.background.cornerRadius = 16
        configure.attributedTitle = .init(title,
                                          attributes: .init([.font : UIFont.pretendard(.body2),
                                                             .foregroundColor : UIColor.textNormal]))
        configure.imagePlacement = .trailing
        
        self.configuration = configure
        
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBinding() {
        $isOpen.sink { [weak self] isOpen in
            let image: UIImage? = isOpen ? .init(named: "i-fol-20") : .init(named: "i-op-20")
            self?.configuration?.image = image
        }.store(in: &cancellable)
    }
}
