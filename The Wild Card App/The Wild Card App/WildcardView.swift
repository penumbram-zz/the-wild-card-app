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

let ACTION_MARGIN : CGFloat = 120.0

class WildcardView: UIView {
    
    var information : UILabel!
    weak var delegate : WildcardViewDelegate!
    
    var panGestureRecognizer : UIPanGestureRecognizer!
    var originalPoint : CGPoint!
    var overlayView : OverlayView!
    
    var xFromCenter : CGFloat!
    var yFromCenter : CGFloat!
    
    var isRight : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        self.setupView()
        self.information = UILabel(frame: CGRect(x: 0, y: 50.0, width: self.frame.size.width ,height:100))
        information.text = "no info given"
        information.textAlignment = .center
        information.textColor = .black
            
        self.backgroundColor = .white
        
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(WildcardView.dragging(_:)))
        
        self.addGestureRecognizer(panGestureRecognizer)
        self.addSubview(information)
        
        overlayView = OverlayView(frame: CGRect(x: self.frame.size.width/2-100,y: 0.0, width: 100.0, height: 100.0))
        overlayView.alpha = 0;
        self.addSubview(overlayView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        self.layer.cornerRadius = 4.0
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    func dragging(_ gestureRecognizer : UIPanGestureRecognizer) {
        xFromCenter = gestureRecognizer.translation(in: self).x
        yFromCenter = gestureRecognizer.translation(in: self).y
        
        
        
        //swiping state
        switch (gestureRecognizer.state) {
            //swiping began
        case .began:
            self.originalPoint = self.center;
            isRight = xFromCenter > 0
            break
        //swiping continues
        case .changed:
            self.center = CGPoint(x: self.originalPoint.x + xFromCenter, y: self.originalPoint.y + yFromCenter)
            self.updateOverlay(distance: xFromCenter)
            break
        case .ended:
            self.afterSwipeAction()
            isRight = false
            break
        default:
            break
        }
    }
    
    // updates with the correct overlay image
    func updateOverlay(distance : CGFloat) {
        if distance > 0 {
            overlayView.mode = .right;
        } else {
            overlayView.mode = .left;
        }
        overlayView.alpha = CGFloat(min(fabsf(Float(distance))/200,Float(0.5)));
    }
    
    //MARK: Right - Left
    
    // called when the wildcard is loose from the user's action
    func afterSwipeAction() {
        if (xFromCenter > ACTION_MARGIN) {
            self.cardAction(direction: .right)
        } else if (xFromCenter < -ACTION_MARGIN) {
            self.cardAction(direction: .left)
        } else { // reset the card
            UIView.animate(withDuration: 0.3, animations:{
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
                self.overlayView.alpha = 0;
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
