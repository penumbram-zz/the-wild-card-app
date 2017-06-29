//
//  OverlayView.swift
//  The Wild Card App
//
//  Created by Tolga Caner on 26/06/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import UIKit

enum OverlayMode {
    case left
    case right
}


class OverlayView : UIView {
    
    
    var imageView : UIImageView!
    
    private var _mode: OverlayMode!
    
    var mode : OverlayMode { set {
        if (newValue != _mode) {
            _mode = newValue
            if(newValue == .left) {
                imageView.image = UIImage(named:"imgNo")
            } else {
                imageView.image = UIImage(named:"imgYes")
            }
            
        }
        
        } get{
            return _mode
        }}
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = .white
        imageView = UIImageView()
        self.addSubview(imageView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame.size = CGSize(width: 90.0, height: 90.0)
        imageView.center = CGPoint(x: self.superview!.frame.size.width/2 - imageView.frame.size.width/2, y: 50.0 + imageView.frame.size.height/2)
    }
    
}
