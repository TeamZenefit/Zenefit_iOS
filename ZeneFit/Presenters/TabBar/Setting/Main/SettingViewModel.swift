//
//  SettingViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/29.
//

import UIKit

final class SettingViewModel {
    weak var coordinator: SettingCoordinator?
    
    // output
    let headerItems: [HeaderModel] = [.init(title: "알림 설정", image: .init(resource: .bell)),
                                      .init(title: "개인 설정", image: .init(resource: .person))]
    
    init(coordinator: SettingCoordinator? = nil) {
        self.coordinator = coordinator
    }
}

struct HeaderModel {
    let title: String
    let image: UIImage
}
