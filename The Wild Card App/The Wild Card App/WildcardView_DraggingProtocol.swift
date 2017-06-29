//
//  WildcardView_DraggingProtocol.swift
//  The Wild Card App
//
//  Created by Tolga Caner on 29/06/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import UIKit

protocol DraggingProtocol : class {
    func dragging(_ gestureRecognizer : UIPanGestureRecognizer)
}

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
            
            //%%% dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
            let rotationStrength = min(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX)
            
            //%%% degree change in radians
            let rotationAngel = ROTATION_ANGLE * rotationStrength
            
            //%%% amount the height changes when you move the card up to a certain point
            let scale = max(1.0 - CGFloat(fabsf(Float(rotationStrength))) / SCALE_STRENGTH, SCALE_MAX)
            
            //%%% rotate by certain amount
            let transform = CGAffineTransform(rotationAngle: rotationAngel)
            let scaledTransform = transform.scaledBy(x: scale, y: scale)
            
            //%%% move the object's center by center + gesture coordinate
            
            let percent = (xFromCenter) * self.layer.affineTransform().a / self.frame.size.width
            
            let rotationPercent = percent
            
            
            let x = abs(percent)
            let scaleX = 1-(2*x);
            var trans = CGAffineTransform(scaleX: scaleX, y: 1.0)
            
            print(scaleX)
            
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
                self.layer.setAffineTransform(.identity)
                self.updateOverlay(distance: xFromCenter)
            }
            //print(scalexx)
            
            
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
