//
//  WildcardView_DraggingProtocol.swift
//  The Wild Card App
//
//  Created by Tolga Caner on 29/06/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import UIKit

extension WildcardView : DraggingProtocol {
    
    
    

    func dragging(_ gestureRecognizer : UIPanGestureRecognizer) {
        xFromCenter = gestureRecognizer.translation(in: self.superview).x
        yFromCenter = gestureRecognizer.translation(in: self.superview).y
        xVelocity = gestureRecognizer.velocity(in: self.superview).x
        
        //swiping state
        switch (gestureRecognizer.state) {
        //swiping began
        case .began:
            self.originalPoint = self.center
            /*
             * memorize the starting state,
             * facingBack might change, movingfromBack stays the same as 
             * long as the finger is on the screen
            */
            self.movingFromBack = self.facingBack
            break
        //swiping continues
        case .changed:
            
            let percent = (xFromCenter) * self.layer.affineTransform().a / self.frame.size.width //percentage of the touch location over the total width of the card
            
            let x = abs(percent) //always positive
            let scaleX = 1 - (2*x) //arbitrary scale value
            var trans : CGAffineTransform
            
            if xFromCenter > 0 { //going right
                self.rotateCard(isBack: self.movingFromBack, scaleX: scaleX, gestureRecognizer: gestureRecognizer)
                if self.movingFromBack {// facing back, no overlay image will be shown
                    overlayView.alpha = 0.0
                } else { //facing front, should update overlay image alpha
                    self.updateOverlay(distance: xFromCenter)
                }
            } else { // going left
                self.updatePosition()
                trans = CGAffineTransform.identity
                if self.facingBack {
                    trans = trans.concatenating(CGAffineTransform(scaleX: -1.0, y: 1.0))
                }
                self.transform = trans
                self.updateOverlay(distance: xFromCenter)
            }
            break
        case .ended:
            self.afterSwipeAction(gestureRecognizer)
            break
        default:
            break
        }
    }
    
    func rotateCard(isBack : Bool, scaleX: CGFloat,gestureRecognizer : UIPanGestureRecognizer) {
        self.layer.setAffineTransform(CGAffineTransform(scaleX: isBack ? -scaleX : scaleX, y: 1.0))
        
        if scaleX <= 0.0 && scaleX > -0.3 {
            self.facingBack = !isBack
        } else if scaleX < -0.3 {
            gestureRecognizer.isEnabled = false
            self.afterSwipeAction(gestureRecognizer)
        } else {
            if scaleX >= 0.0 {
                self.facingBack = isBack
            }
            self.updatePosition()
        }
    }
    
    func updatePosition() {
        self.center = CGPoint(x: self.originalPoint.x + xFromCenter, y: self.originalPoint.y + yFromCenter)
    }
    
    // updates with the correct overlay image
    func updateOverlay(distance : CGFloat) {
        if distance > 0 {
            overlayView.mode = .right
        } else {
            overlayView.mode = .left
        }
        overlayView.alpha = CGFloat(min(fabsf(Float(distance))/200,Float(0.5)))
    }
}
