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

class FetchCommand : Command {
    var completionHandler: ([WildcardEntity]) -> Void
    
    required init(completionHandler: @escaping ([WildcardEntity])->Void) {
        self.completionHandler = completionHandler
    }
    
    func execute() {
        NetworkManager.sharedInstance.request("http://www.mocky.io/v2/595208f30f00001c01a3d6fc", method: .get, parameters: nil).responseObject {(response: DataResponse<WildcardResponse>) in
            if let wildcardResponse = response.result.value, wildcardResponse.data != nil, wildcardResponse.data!.count > 0 {
                self.completionHandler(wildcardResponse.data!)
            }
        }
    }
}
