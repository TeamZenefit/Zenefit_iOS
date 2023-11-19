//
//  BookmarkViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/30.
//

import Foundation
import Combine

final class BookmarkViewModel {
    weak var coordinator: HomeCoordinator?
    
    @Published var isEditMode: Bool = false
    var bookmarkList: [String] = ["1","2","3"]
    
    init(coordinator: HomeCoordinator? = nil) {
        self.coordinator = coordinator
    }
}
