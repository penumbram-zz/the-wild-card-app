//
//  WildcardView_ViewSetupProtocol.swift
//  The Wild Card App
//
//  Created by Tolga Caner on 29/06/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import UIKit

extension WildcardView {
    
    func initFrontView() {
        let vFront = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height))
        vFront.backgroundColor = .white
        self.addSubview(vFront)
        self.frontView = vFront
        
        self.initProfilePicture()
        self.initNameLabel()
        self.initAgeLabel()
        self.initCityLabel()
        self.initSmokingLabel()
        self.initProfessionLabel()
        self.initChildrenLabel()
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
    
    func initNameLabel() {
        let lblName = UILabel(frame: CGRect(x: 0, y: 140.0, width: self.frame.size.width ,height:30))
        lblName.textAlignment = .center
        self.frontView.addSubview(lblName)
        self.labelName = lblName
    }
    
    func initAgeLabel() {
        let lblAge = UILabel(frame: CGRect(x: 0, y: 170.0, width: self.frame.size.width ,height:30))
        lblAge.textAlignment = .center
        self.frontView.addSubview(lblAge)
        self.labelAge = lblAge
    }
    
    func initCityLabel() {
        let lbl = UILabel(frame: CGRect(x: 0, y: 200.0, width: self.frame.size.width ,height:30))
        lbl.textAlignment = .center
        self.frontView.addSubview(lbl)
        self.labelCity = lbl
    }
    
    func initProfessionLabel() {
        let lbl = UILabel(frame: CGRect(x: 0, y: 230.0, width: self.frame.size.width ,height:30))
        lbl.textAlignment = .center
        self.frontView.addSubview(lbl)
        self.labelProfession = lbl
    }
    
    func initSmokingLabel() {
        let lbl = UILabel(frame: CGRect(x: 0, y: 260.0, width: self.frame.size.width ,height:30))
        lbl.textAlignment = .center
        self.frontView.addSubview(lbl)
        self.labelSmoking = lbl
    }
    
    func initChildrenLabel() {
        let lbl = UILabel(frame: CGRect(x: 0, y: 290.0, width: self.frame.size.width ,height:30))
        lbl.textAlignment = .center
        self.frontView.addSubview(lbl)
        self.labelChildren = lbl
    }
    
    func initProfilePicture() {
        let ivProfile = UIImageView(frame: CGRect(x: 0.0, y: 50.0, width: 90.0 ,height:90.0))
        ivProfile.contentMode = .scaleAspectFill
        ivProfile.layer.cornerRadius = ivProfile.frame.width/2.0
        ivProfile.layer.masksToBounds = true
        
        ivProfile.center = CGPoint(x: self.frame.size.width/2, y: ivProfile.center.y)
        self.frontView.addSubview(ivProfile)
        self.ivProfile = ivProfile
    }
    
}

extension WildcardView { //Back View
    
    func initDummyLabel() {
        let lblDummy = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 200.0, height: 30.0))
        lblDummy.text = "Send First Message Here!"
        lblDummy.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.backView.addSubview(lblDummy)
        lblDummy.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
    }
    
}
