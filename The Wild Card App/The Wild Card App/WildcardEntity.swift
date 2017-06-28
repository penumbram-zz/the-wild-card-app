//
//  WildcardEntity.swift
//  The Wild Card App
//
//  Created by Tolga Caner on 27/06/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import Foundation
import ObjectMapper

class WildcardEntity : Mappable {
    
    required init?(map: Map) {}

    var id: Int64?
    var name: String?
    var age: Int?
    var city : String?
    var profession : String?
    var isSmoker: Bool?
    var wishesChildren: Bool?
    var profilePictureUrl : String?
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        age <- map["age"]
        city <- map["city"]
        profession <- map["profession"]
        isSmoker <- map["smoker"]
        wishesChildren <- map["wish_children"]
        profilePictureUrl <- map["profile_picture_url"]
    }
    
}
