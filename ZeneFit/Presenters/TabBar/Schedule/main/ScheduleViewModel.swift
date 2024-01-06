//
//  ScheduleViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/5/24.
//

import Foundation

class ScheduleViewModel {
    weak var coordinator: ScheduleCoordinator?
    
    init(coordinator: ScheduleCoordinator? = nil) {
        self.coordinator = coordinator
    }
}
