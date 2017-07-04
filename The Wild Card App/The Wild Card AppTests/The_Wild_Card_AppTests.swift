//
//  The_Wild_Card_AppTests.swift
//  The Wild Card AppTests
//
//  Created by Tolga Caner on 26/06/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import XCTest
@testable import The_Wild_Card_App
import Alamofire

class The_Wild_Card_AppTests: XCTestCase {
    
    func testWildcardsRouter() {
        let wildcardsModule = WildcardsRouter.createModule()
        XCTAssertNotNil(wildcardsModule)
    }
    
    func testEndpoint() {
        let promise = expectation(description: "Movie Response is in place")
        
        NetworkManager.sharedInstance.request(endpoint, method: .get, parameters: nil).responseArray {(response: DataResponse<[WildcardEntity]>) in
            if response.result.value != nil {
                promise.fulfill()
            } else {
                XCTFail("Response value is not of type WildcardResponse")
            }
        }
        // 3
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testOneCard() {
        let wildcardContainer = dummyWildcardContainer()
        wildcardContainer.cardsData = [dummyWildcardEntity()]
        
        XCTAssertTrue(wildcardContainer.loadedCards.count == 1)
        XCTAssertTrue(wildcardContainer.cardsData.count == 1)
    }
    
    func testTwoCards() {
        let wildcardContainer = dummyWildcardContainer()
        wildcardContainer.cardsData = [dummyWildcardEntity(), dummyWildcardEntity()]
        
        XCTAssertTrue(wildcardContainer.loadedCards.count == 2)
        XCTAssertTrue(wildcardContainer.cardsData.count == 2)
    }
    
    func testThreeCards() {
        let wildcardContainer = dummyWildcardContainer()
        wildcardContainer.cardsData = [dummyWildcardEntity(), dummyWildcardEntity(), dummyWildcardEntity()]
        
        XCTAssertTrue(wildcardContainer.loadedCards.count == 3)
        XCTAssertTrue(wildcardContainer.cardsData.count == 3)
    }
    
    func testTwentyCards() {
        let wildcardContainer = dummyWildcardContainer()
        var arr : [WildcardEntity] = []
        for _ in 0..<20 {
            arr.append(dummyWildcardEntity())
        }
        wildcardContainer.cardsData = arr
        
        XCTAssertTrue(wildcardContainer.loadedCards.count == 3)
        XCTAssertTrue(wildcardContainer.cardsData.count == 20)
    }
    
    func testCardSwipe() {
        let wildcardContainer = dummyWildcardContainer()
        wildcardContainer.cardsData = [dummyWildcardEntity()]
        let wildcard = wildcardContainer.createDraggableViewWithDataAt(index: 0)
        wildcard.panGestureRecognizer.isEnabled = true
        wildcardContainer.cardSwiped(wildcard)
        XCTAssertFalse(wildcard.panGestureRecognizer.isEnabled)        
    }
    
    func dummyWildcardContainer() -> WildcardContainer {
        return WildcardContainer(frame: CGRect(x: 0.0, y: 0.0, width: 320.0, height: 400.0))
    }
    
    
    func dummyWildcardEntity() -> WildcardEntity {
        let entity = WildcardEntity(JSON: ["age": 27,
                                           "city": "Istanbul",
                                           "firstname": "Tolga",
                                           "id": "113595f5-b58f-4c6a-800d-7b787cd2e79a",
                                           "job": "iOS Developer",
                                           "images" : ["https://scontent-frx5-1.xx.fbcdn.net/v/t1.0-9/11990448_10153044355616811_6985420975763035287_n.jpg?oh=08e70de065ef5a52cce9998c13f6c708&oe=59C5CFA5"],
                                           "name": "Tolga Caner",
                                           "postcode" : "34456",
                                           "smoker" : false,
                                           "total_images" : 1,
                                           "wish_for_children": false])
        return entity!
    }
    
}
