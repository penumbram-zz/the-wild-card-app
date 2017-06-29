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

let ACTION_MARGIN : CGFloat = 120.0 //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
let SCALE_STRENGTH : CGFloat = 4.0 //%%% how quickly the card shrinks. Higher = slower shrinking
let SCALE_MAX : CGFloat = 0.93 //%%% upper bar for how much the card shrinks. Higher = shrinks less
let ROTATION_MAX : CGFloat = 1.0 //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
let ROTATION_STRENGTH : CGFloat = 320.0 //%%% strength of rotation. Higher = weaker rotation
let ROTATION_ANGLE = CGFloat.pi/8 //%%% Higher = stronger rotation angle

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
