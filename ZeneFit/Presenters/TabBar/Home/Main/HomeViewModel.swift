//
//  HomeViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/29.
//

import Foundation

final class HomeViewModel {
    weak var coordinator: HomeCoordinator?
    
    init(coordinator: HomeCoordinator? = nil) {
        self.coordinator = coordinator
    }
    
    func fetchBenefitList() {
        coordinator
    }
}
