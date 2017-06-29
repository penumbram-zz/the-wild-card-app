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
            self.movingFromBack = self.facingBack
            break
        //swiping continues
        case .changed:
            
            let percent = (xFromCenter) * self.layer.affineTransform().a / self.frame.size.width
            
            
            let x = abs(percent)
            let scaleX = 1-(2*x);
            var trans = CGAffineTransform(scaleX: scaleX, y: 1.0)
            
            if xFromCenter > 0 { //going right
                if self.movingFromBack {
                    trans = CGAffineTransform(scaleX: -scaleX, y: 1.0)
                    self.layer.setAffineTransform(trans)
                    overlayView.alpha = 0.0
                    
                    if scaleX <= 0.0 && scaleX > -0.3 {
                        self.facingBack = false
                    } else if scaleX < -0.3 {
                        gestureRecognizer.isEnabled = false
                        self.afterSwipeAction(gestureRecognizer)
                    } else {
                        if scaleX >= 0.0 {
                            self.facingBack = true
                        }
                        self.center = CGPoint(x: self.originalPoint.x + xFromCenter, y: self.originalPoint.y + yFromCenter)
                    }
                } else { //facing front
                    self.layer.setAffineTransform(trans)
                    if scaleX <= 0.0 && scaleX > -0.3 {
                        self.facingBack = true
                    } else if scaleX < -0.3 {
                        gestureRecognizer.isEnabled = false
                        self.afterSwipeAction(gestureRecognizer)
                    } else {
                        if scaleX >= 0.0 {
                            self.facingBack = false
                        }
                        self.center = CGPoint(x: self.originalPoint.x + xFromCenter, y: self.originalPoint.y + yFromCenter)
                    }
                    self.updateOverlay(distance: xFromCenter)
                }
            } else {
                self.center = CGPoint(x: self.originalPoint.x + xFromCenter, y: self.originalPoint.y + yFromCenter)
                var trans = CGAffineTransform.identity
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
