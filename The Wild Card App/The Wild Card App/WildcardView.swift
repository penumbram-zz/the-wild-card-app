//
//  WildcardView.swift
//  The Wild Card App
//
//  Created by Tolga Caner on 26/06/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import UIKit
import SDWebImage

enum SwipeDirection {
    case left
    case right
}

protocol WildcardViewDelegate : class {
    func cardSwiped(_ card : WildcardView, direction: SwipeDirection)
}



class WildcardView: UIView, ViewSetupProtocol {
    
    let ACTION_MARGIN : CGFloat //distance from center where the action is applied
    let SCALE_STRENGTH : CGFloat = 4.0 //shrinking speed
    let SCALE_MAX : CGFloat = 0.93 //self explanatory max scale
    let ROTATION_MAX : CGFloat = 1.0 //max rotation
    let ROTATION_STRENGTH : CGFloat = 320.0 // rotation duration handle
    let ROTATION_ANGLE = CGFloat.pi/8 // rotation angle handle
    
    weak var frontView : UIView!
    weak var backView : UIView!
    var facingBack : Bool = false {
        didSet {
            self.frontView.isHidden = facingBack
            self.backView.isHidden = !facingBack
        }
    }
    var movingFromBack = false
    
    weak var labelName : UILabel!
    weak var ivProfile : UIImageView!
    weak var labelAge : UILabel!
    weak var labelCity : UILabel!
    weak var labelProfession : UILabel!
    weak var labelSmoking : UILabel!
    weak var labelChildren : UILabel!
    
    weak var delegate : WildcardViewDelegate!
    
    var panGestureRecognizer : UIPanGestureRecognizer!
    var originalPoint : CGPoint!
    weak var overlayView : OverlayView!
    
    var xFromCenter : CGFloat!
    var yFromCenter : CGFloat!
    var xVelocity : CGFloat!
    
    
    init(frame: CGRect, entity: WildcardEntity) {
        ACTION_MARGIN = frame.size.width/2
        super.init(frame: frame)
        self.setupView() //setup views
        self.fillCard(item: entity) //fill the data
    }
    
    func fillCard(item: WildcardEntity) {
        self.labelName.text = item.name
        self.labelAge.text = "Age: \(item.age!)"
        self.labelCity.text = "City: \(item.city!)"
        self.labelChildren.text = "Wishes Children: " + (item.wishesChildren! ? "YES" : "NO")
        self.labelSmoking.text = "Smoker: " + (item.isSmoker! ? "YES" : "NO")
        self.labelProfession.text = "Profession: \(item.profession!)"
        
        
        self.ivProfile.sd_setImage(with: URL(string: item.profilePictureUrl!), placeholderImage: UIImage(named:"profile_placeholder"), options: SDWebImageOptions.cacheMemoryOnly, completed: nil)
    }
    
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
