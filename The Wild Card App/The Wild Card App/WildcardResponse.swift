//
//  WildcardResponse.swift
//  The Wild Card App
//
//  Created by Tolga Caner on 27/06/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import Foundation
import ObjectMapper

class WildcardResponse : Mappable {
    
    required init?(map: Map) {}
    
    var data : [WildcardEntity]?
    func mapping(map: Map) {
        data <- map["data"]
    }
    
}
