//
//  WildcardView.swift
//  The Wild Card App
//
//  Created by Tolga Caner on 26/06/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import UIKit

enum SwipeDirection {
    case left
    case right
}

protocol WildcardViewDelegate : class {
    func cardSwiped(_ card : WildcardView, direction: SwipeDirection)
}

let ACTION_MARGIN : CGFloat = 120.0 //distance from center where the action is applied
let SCALE_STRENGTH : CGFloat = 4.0 //shrinking speed
let SCALE_MAX : CGFloat = 0.93 //self explanatory max scale
let ROTATION_MAX : CGFloat = 1.0 //max rotation
let ROTATION_STRENGTH : CGFloat = 320.0 // rotation duration handle
let ROTATION_ANGLE = CGFloat.pi/8 // rotation angle handle

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
    
}
