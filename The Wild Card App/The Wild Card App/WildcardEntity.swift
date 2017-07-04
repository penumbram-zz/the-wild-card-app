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

    var age: Int?
    var city : String?
    var firstName: String?
    var id: String?
    var images : [String]?
    var profession : String?
    var name: String?
    var postCode: String?
    var isSmoker: Bool?
    var totalImages: Int?
    var wishesChildren: Bool?
    
    func mapping(map: Map) {
        age <- map["age"]
        city <- map["city"]
        firstName <- map["firstname"]
        id <- map["id"]
        images <- map["images"]
        profession <- map["job"]
        name <- map["name"]
        postCode <- map["postcode"]
        isSmoker <- map["smoker"]
        totalImages <- map["total_images"]
        wishesChildren <- map["wish_for_children"]
    }
    
}
