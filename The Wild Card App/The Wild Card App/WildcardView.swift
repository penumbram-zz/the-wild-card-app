//
//  WildcardView.swift
//  The Wild Card App
//
//  Created by Tolga Caner on 26/06/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import UIKit


protocol ViewSetupProtocol : class {
    func setupView()
}

enum SwipeDirection {
    case left
    case right
}

protocol WildcardViewDelegate : class {
    func cardSwiped(_ card : WildcardView, direction: SwipeDirection)
}

let ACTION_MARGIN : CGFloat = 120.0

class WildcardView: UIView {
    
    weak var frontView : UIView!
    weak var backView : UIView!
    var facingBack : Bool = false {
        didSet {
            self.frontView.isHidden = facingBack
            self.backView.isHidden = !facingBack
        }
    }
    var movingFromBack = false
    
    weak var information : UILabel!
    weak var delegate : WildcardViewDelegate!
    
    var panGestureRecognizer : UIPanGestureRecognizer!
    var originalPoint : CGPoint!
    weak var overlayView : OverlayView!
    
    var xFromCenter : CGFloat!
    var yFromCenter : CGFloat!
    var xVelocity : CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    //MARK: Right - Left
    
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
                self.transform = CGAffineTransform(rotationAngle: 0)
                self.overlayView.alpha = 0
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
