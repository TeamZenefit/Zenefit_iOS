//
//  GestureType.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/30.
//

import UIKit

enum GestureType {
    case tap(UITapGestureRecognizer = .init())
    case longPress(UILongPressGestureRecognizer = .init())
    case pan(UIPanGestureRecognizer = .init())
    case pinch(UIPinchGestureRecognizer = .init())
    case swipe(UISwipeGestureRecognizer = .init())
    case edge(UIScreenEdgePanGestureRecognizer = .init())
    
    var gesture: UIGestureRecognizer {
        switch self {
        case let .tap(tapGesture):
            return tapGesture
        case let .longPress(longPressGesture):
            return longPressGesture
        case let .pan(panGesture):
            return panGesture
        case let .pinch(pinchGesture):
            return pinchGesture
        case let .swipe(swipeGesture):
            return swipeGesture
        case let .edge(edgePanGesture):
            return edgePanGesture
        }
    }
}
