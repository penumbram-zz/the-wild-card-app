//
//  WildcardViewProtocols.swift
//  The Wild Card App
//
//  Created by Tolga Caner on 29/06/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import UIKit

protocol SwipingProtocol : class {
    func afterSwipeAction(_ gestureRecognizer : UIPanGestureRecognizer)
    func cardAction(direction: SwipeDirection)
}

protocol DraggingProtocol : class {
    func dragging(_ gestureRecognizer : UIPanGestureRecognizer)
}

protocol ViewSetupProtocol : class {
    func setupView()
}
