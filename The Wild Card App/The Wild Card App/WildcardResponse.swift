//
//  WildcardResponse.swift
//  The Wild Card App
//
//  Created by Tolga Caner on 27/06/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import Foundation
import ObjectMapper

final class WildcardResponseList<WildcardEntity : Mappable> : Mappable {
    
    var result : [WildcardEntity]?
    
    required convenience init?(map: Map) {
        self.init(map: map)
    }
    
    
    func mapping(map: Map) {
        result <- map["result"]
    }
    
}
