//
//  BenefitViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/02.
//

import Foundation

final class BenefitViewModel {
    weak var coordinator: HomeCoordinator?
    
    @Published var isEditMode: Bool = false
    var policyList: [String] = ["1","2","3"]
    
    init(coordinator: HomeCoordinator? = nil) {
        self.coordinator = coordinator
    }
}
