//
//  WelfareViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/05.
//

import Foundation

final class WelfareViewModel {
    weak var coordinator: WelfareCoordinator?
    
    @Published var policyItems: [String] = ["현금 정책", "대출 정책", "사회 서비스"]
    
    init(coordinator: WelfareCoordinator? = nil) {
        self.coordinator = coordinator
    }
    
    
}
