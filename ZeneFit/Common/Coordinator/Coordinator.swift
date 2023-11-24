//
//  Coordinator.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/09/28.
//

import UIKit

protocol CoordinatorDelegate: AnyObject {
    func didFinish(childCoordinator: any Coordinator)
}

protocol Coordinator: AnyObject {
    
    associatedtype CoordinatorAction
    
    var childCoordinators: [any Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var delegate: CoordinatorDelegate? { get set }
    
    func setAction(_ action: CoordinatorAction)
    func start()
    func finish()
}

extension Coordinator {
    func finish() {
        childCoordinators = []
        delegate?.didFinish(childCoordinator: self)
    }
}
