//
//  WildcardView_ViewSetupProtocol.swift
//  The Wild Card App
//
//  Created by Tolga Caner on 29/06/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import UIKit

extension WildcardView : ViewSetupProtocol {
    
    func setupView() {
        self.layer.cornerRadius = 4.0
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.backgroundColor = .white
        
        self.initFrontView()
        self.initBackView()
        self.initOverlayView()
        self.addPanGestureRecognizer()
    }
    
    func initFrontView() {
        let vFront = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height))
        vFront.backgroundColor = .white
        self.addSubview(vFront)
        self.frontView = vFront
        
        self.initInfoLabel()
    }
    
    func initBackView() {
        let vBack = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height))
        vBack.backgroundColor = .lightGray
        self.addSubview(vBack)
        self.backView = vBack
        self.backView.isHidden = true
        
        self.initDummyLabel()
    }
    
    func initOverlayView() {
        let vOverlay = OverlayView(frame: CGRect(x: self.frame.size.width/2-100,y: 0.0, width: 100.0, height: 100.0))
        vOverlay.alpha = 0
        self.frontView.addSubview(vOverlay)
        self.overlayView = vOverlay
    }
    
    func addPanGestureRecognizer() {
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(WildcardView.dragging(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
    }

}


extension WildcardView { //Front View
    
    func initInfoLabel() {
        let lblInformation = UILabel(frame: CGRect(x: 0, y: 50.0, width: self.frame.size.width ,height:100))
        lblInformation.isOpaque = false
        lblInformation.text = "no info given"
        lblInformation.textAlignment = .center
        lblInformation.textColor = .black
        self.frontView.addSubview(lblInformation)
        self.information = lblInformation
    }
    
    func initDummyLabel() {
        let lblDummy = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 200.0, height: 30.0))
        lblDummy.text = "Send First Message Here!"
        lblDummy.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.backView.addSubview(lblDummy)
        lblDummy.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
    }
    
}
