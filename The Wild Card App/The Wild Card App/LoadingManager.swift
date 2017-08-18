//
//  LoadingManager.swift
//  The Wild Card App
//
//  Created by Tolga Caner on 27/06/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import Foundation
import SVProgressHUD


public class LoadingManager {
    
    static func prepare() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setRingRadius(24.0)
    }
    
    static func showLoading() {
        SVProgressHUD.show()
    }
    
    static func hideLoading() {
        SVProgressHUD.dismiss()
    }
}
