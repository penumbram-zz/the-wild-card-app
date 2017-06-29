//
//  WildcardView_SwipingProtocol.swift
//  The Wild Card App
//
//  Created by Tolga Caner on 29/06/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import UIKit

extension WildcardView : SwipingProtocol {
  
    // called when the wildcard is loose from the user's action
    func afterSwipeAction(_ gestureRecognizer : UIPanGestureRecognizer) {
        if (xFromCenter > ACTION_MARGIN) {
            UIView.animate(withDuration: 0.3, animations:{
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0).concatenating(CGAffineTransform(scaleX: self.movingFromBack ? 1.0 : -1.0, y: 1.0))
                self.overlayView.alpha = 0
                gestureRecognizer.isEnabled = true
            })
            //self.cardAction(direction: .right)
        } else if (xFromCenter < -ACTION_MARGIN) {
            self.cardAction(direction: .left)
        } else { // reset the card
            UIView.animate(withDuration: 0.3, animations:{
                self.center = self.originalPoint
                var trans = CGAffineTransform(rotationAngle: 0)
                if self.facingBack {
                    trans = trans.concatenating(CGAffineTransform(scaleX: -1.0, y: 1.0))
                }
                self.transform = trans
                self.overlayView.alpha = 0
                gestureRecognizer.isEnabled = true
            })
        }
    }
    
    //called when a swipe exceeds the ACTION_MARGIN to the given direction
    func cardAction(direction: SwipeDirection)
    {
        let isRight = direction == .right
        let finishPoint = CGPoint(x: isRight ? 500.0 : -500.0, y: 2*yFromCenter + self.originalPoint.y)
        UIView.animate(withDuration: 0.3, animations:{
            self.center = finishPoint
            self.transform = CGAffineTransform(rotationAngle: isRight ? 1 : -1)
        }) {finished in
            self.removeFromSuperview()
        }
        
        delegate.cardSwiped(self, direction: direction)
    }

    
    
}
