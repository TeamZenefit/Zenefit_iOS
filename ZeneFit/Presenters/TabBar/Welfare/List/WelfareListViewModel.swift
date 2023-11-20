//
//  WelfareListViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/05.
//

import Foundation

final class WelfareListViewModel {
    weak var coordinator: WelfareCoordinator?
    
    let type: SupportPolicyType
    
    let categories = ["전체","취업","창업","주거∙금융","생활","사회 참여"]
    
    let items = ["1","2","3","4","5","6","7","8"]
    
    @Published var selectedCategory = "전체"
    
    init(coordinator: WelfareCoordinator? = nil, type: SupportPolicyType) {
        self.coordinator = coordinator
        self.type = type
    }
}
