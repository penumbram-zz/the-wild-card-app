//
//  The_Wild_Card_AppUITests.swift
//  The Wild Card AppUITests
//
//  Created by Tolga Caner on 26/06/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import XCTest

class The_Wild_Card_AppUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testRightSwipe() {
        let app = XCUIApplication()
        let backlabel = self.backLabel(app)
        let topCard = cardWithIdentifier("top card", app)
        XCTAssertFalse(backlabel.exists)
        topCard?.swipeRight()
        XCTAssertTrue(backlabel.exists)
        topCard?.swipeRight()
        XCTAssertFalse(backlabel.exists)
    }
    func testRightSwipeExtensive() {
        let app = XCUIApplication()
        let backLabel = self.backLabel(app)
        XCTAssertFalse(backLabel.exists)
        for i in 1..<30 {
            let topcard = cardWithIdentifier("top card", app)
            XCTAssertTrue(topcard!.exists)
            topcard?.swipeRight()
            XCTAssertEqual(backLabel.exists, Bool((i % 2) as NSNumber))
        }
    }
    func testLeftSwipe() {
        let app = XCUIApplication()
        
        self.swipeOffAllCards(app)
        XCTAssertFalse(self.finishedLabel(app).exists)
    }
 
    func testSwipeEmptyScreenExcessive() {
        let app = XCUIApplication()
        self.swipeOffAllCards(app)
        let mainView = app.windows.children(matching: .any).matching(identifier: "wildcards view controller view").element
        for i in 0..<10 {
            ((i % 2) == 0) ? mainView.swipeLeft() : mainView.swipeRight() //would it cause any kind of crash?
        }
        XCTAssertFalse(self.finishedLabel(app).exists)
    }
 
    func testBackTurnedSwipeOff() {
        let app = XCUIApplication()
        while let card = cardWithIdentifier("top card", app) {
            card.swipeRight()
            XCTAssertTrue(self.backLabel(app).exists)
            card.swipeLeft()
            XCTAssertFalse(self.backLabel(app).exists)
        }
        XCTAssertFalse(self.finishedLabel(app).exists)
    }
    
    func testReusedCards() {
        let app = XCUIApplication()
        var card = cardWithIdentifier("top card", app)
        card?.swipeRight()
        card?.swipeLeft()
        card = cardWithIdentifier("top card", app)
        card?.swipeRight()
        let reusedCard = cardWithIdentifier("bottom card", app)
        let backLabel = reusedCard?.children(matching: .any).staticTexts[backText]
        XCTAssertFalse(backLabel!.exists)
        let topBackLabel = self.backLabel(app)
        XCTAssertTrue(topBackLabel.exists)
        print("yoyo")
    }
    
    //MARK: Reused Helper Functions
    
    let backText = "Send First Message Here!"
    
    func cardWithIdentifier(_ identifier : String,_ app : XCUIApplication) -> XCUIElement? {
        let query = app.windows.children(matching: .any).matching(identifier: "wildcards view controller view").children(matching: .any).matching(identifier: "wildcard container view").children(matching: .any).matching(identifier: identifier)
        if query.count == 1 {
            return query.element
        } else {
            return nil
        }
    }
    
    func backLabel(_ app : XCUIApplication) -> XCUIElement {
        let lbl = app.staticTexts[backText]
        return lbl
    }
    
    func finishedLabel(_ app : XCUIApplication) -> XCUIElement {
        let lbl = app.staticTexts["Cards Left: 0"]
        return lbl
    }
    
    func swipeOffAllCards(_ app : XCUIApplication) {
        while let card = cardWithIdentifier("top card", app) {
            card.swipeLeft()
        }
    }
    
}
