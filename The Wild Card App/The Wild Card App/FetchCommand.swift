//
//  DataCommand.swift
//  The Wild Card App
//
//  Created by Tolga Caner on 27/06/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import Foundation

import Alamofire
import AlamofireObjectMapper

protocol Command {
    func execute()
}

let endpoint = "http://devrecruitmentapi-affinitasplaygroundstaticbucket-129egsam02uuk.s3-website-eu-west-1.amazonaws.com/"

class FetchCommand : Command {
    var completionHandler: ([WildcardEntity]) -> Void
    
    required init(completionHandler: @escaping ([WildcardEntity])->Void) {
        self.completionHandler = completionHandler
    }
    
    func execute() {
        NetworkManager.sharedInstance.request(endpoint, method: .get, parameters: nil).responseArray { (response: DataResponse<[WildcardEntity]>) in
            if let wildcardResponse = response.result.value, wildcardResponse.count > 0 {
                self.completionHandler(wildcardResponse)
            }
        }
    }
}
