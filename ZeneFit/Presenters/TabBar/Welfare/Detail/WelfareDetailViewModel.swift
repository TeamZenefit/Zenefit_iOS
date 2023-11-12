//
//  WelfareDetailViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/12/23.
//

import Foundation

final class WelfareDetailViewModel {
    weak var coordinator: WelfareCoordinator?
    
    init(coordinator: WelfareCoordinator? = nil) {
        self.coordinator = coordinator
    }
}
