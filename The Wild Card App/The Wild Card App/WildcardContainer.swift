//
//  WildcardContainer.swift
//  The Wild Card App
//
//  Created by Tolga Caner on 27/06/2017.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import UIKit
import SDWebImage

class WildcardContainer: UIView, WildcardViewDelegate {
    
    weak var cardCountDelegate : CardCountDelegate?
    
    var cardsData : [WildcardEntity]! {
        didSet {
            self.loadCards()
        }
    }
    
    var cardsLoadedIndex : Int!
    var loadedCards : [WildcardView]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        self.accessibilityLabel = "wildcard container view"
        loadedCards = []
        cardsLoadedIndex = 0
        self.CARD_FRAME = CGRect(x: (self.frame.size.width - CARD_WIDTH)/2, y: (self.frame.size.height - CARD_HEIGHT)/2, width: CARD_WIDTH, height: CARD_HEIGHT)
    }
    
    
    let MAX_VISIBLE_CARDS = 3 // Max number of cards loaded at any given time, must be greater than 1
    let CARD_HEIGHT : CGFloat = 386.0 // Height constant for a wildcard
    let CARD_WIDTH : CGFloat = 290.0 // Width constant for a wildcard
    let CARD_TOP_MARGIN : CGFloat = 20.0
    var CARD_FRAME : CGRect!
    
    func loadCards() {
        if cardsData.count > 0 {
            let numLoadedCardsCap = (cardsData.count > MAX_VISIBLE_CARDS) ? MAX_VISIBLE_CARDS : cardsData.count
            // If the the cardsData count is greated than MAX_VISIBLE_CARDS, it would lead to an array out of bounds exception without this check
            
            for i in 0..<cardsData.count {
                if i < numLoadedCardsCap {
                    let newCard = self.createDraggableViewWithDataAt(index: i) //create a new card
                    loadedCards.append(newCard) //add it to loaded cards (max 3)
                }
            }
            
            //Display cards
            for i in 0..<loadedCards.count {
                if i>0 {
                    self.insertNewCardBelow(index: i)
                } else {
                    self.addSubview(loadedCards[i])
                    self.enableTopCard() //always enable first card
                }
                cardsLoadedIndex = cardsLoadedIndex + 1 // increment the index
            }
        }
    }
    
    func insertNewCardBelow(index : Int) {
        loadedCards[index].frame.origin.y -= (CGFloat(index) *  CARD_TOP_MARGIN)//
        self.insertSubview(loadedCards[index], belowSubview: loadedCards[index-1])
    }
    
    // Creates a new view for a new card
    func createDraggableViewWithDataAt(index : Int) -> WildcardView
    {
        let wildcardView = WildcardView(frame: CARD_FRAME, entity: cardsData[index])

        wildcardView.delegate = self;
        wildcardView.panGestureRecognizer.isEnabled = false
        return wildcardView;
    }
    
    
    //MARK: Swipe Actions
    
    
    //Called when the user swipes a card
    func cardSwiped(_ card : WildcardView, direction: SwipeDirection) {
        let wildcardView = loadedCards.first!
        //make the correct/wrong overlay all visible
        UIView.animate(withDuration: 0.2, animations: {
            wildcardView.overlayView.alpha = 1.0
        }) { finished in
            wildcardView.overlayView.alpha = 0.0
        }
        self.cardSwiped(card)
    }
    
    func cardSwiped(_ card : WildcardView) {
        card.transform = .identity
        card.layer.removeAllAnimations()
        
        card.panGestureRecognizer.isEnabled = false
        
        card.accessibilityLabel = "bottom card"
        
        let removedCard = self.loadedCards.remove(at: 0) //remove latest card
        var remainingCards : Int
        if cardsLoadedIndex < cardsData.count { // if we haven't reached the end of all cards, put another into the loaded cards
            remainingCards = self.cardsData.count + MAX_VISIBLE_CARDS - cardsLoadedIndex - 1
            
            removedCard.fillCard(item: cardsData[cardsLoadedIndex])
            self.loadedCards.append(removedCard)
            for card in self.loadedCards {
                card.frame.origin.y += CARD_TOP_MARGIN //Descend the cards at the top by top margin constant IF it's not the end of the card deck
            }

            
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertNewCardBelow(index: MAX_VISIBLE_CARDS-1)
        } else {
            card.removeFromSuperview()
            remainingCards = loadedCards.count
        }
        
        card.frame = self.CARD_FRAME
        card.frame.origin.y -= CARD_TOP_MARGIN*2
        card.facingBack = false
        
        if self.loadedCards.count > 0 {
            self.enableTopCard()
        } // enable the  gesture recognizer for the top card
        self.cardCountDelegate?.updateCardCount(val: remainingCards) //Update count
        
    }
    
    func enableTopCard() {
        self.loadedCards[0].panGestureRecognizer.isEnabled = true
        self.loadedCards[0].accessibilityLabel = "top card"
    }
    
}
