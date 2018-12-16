//
//  SetGame.swift
//  SetGame
//
//  Created by Mehrab on 19/05/2018.
//  Copyright © 2018 Mehrab. All rights reserved.
//

import Foundation

struct SetGame {
    private(set) var deck = [Card]()
    var cardsOnBoard = [Card]()
    var selectedCards = [Card]()
    var collectedSets = 0
    var point = 0
    var date = Date()
    
    init() {
        print(date)
        for number in Card.Number.all {
            for symbol in Card.Symbol.all {
                for shading in Card.Shading.all {
                    for color in Card.Color.all {
                        deck.append(Card(number: number, symbol: symbol, shading: shading, color: color))
                    }
                }
            }
        }
    }
    
    mutating func draw() -> Card? {
        if deck.count > 0 {
            return deck.remove(at: Int(arc4random_uniform(UInt32(deck.count))))
        } else {
            return nil
        }
    }
    
    mutating func startGame() {
        for _ in 0..<12 {
            cardsOnBoard.append(draw()!)
        }
    }
    
    func isMatched(for cards: [Card]) -> Bool {
        
        var symbolMatched = false
        if (cards[0].symbol == cards[1].symbol) && (cards[1].symbol == cards[2].symbol) && (cards[2].symbol == cards[0].symbol) ||
            (cards[0].symbol != cards[1].symbol) && (cards[1].symbol != cards[2].symbol) && (cards[2].symbol != cards[0].symbol) {
            symbolMatched = true
        }
        
        var numberMatched = false
        if (cards[0].number == cards[1].number) && (cards[1].number == cards[2].number) && (cards[2].number == cards[0].number) ||
            (cards[0].number != cards[1].number) && (cards[1].number != cards[2].number) && (cards[2].number != cards[0].number) {
            numberMatched = true
        }
        
        var colorMatched = false
        if (cards[0].color == cards[1].color) && (cards[1].color == cards[2].color) && (cards[2].color == cards[0].color) ||
            (cards[0].color != cards[1].color) && (cards[1].color != cards[2].color) && (cards[2].color != cards[0].color) {
            colorMatched = true
        }
        
        var shadingMatched = false
        if (cards[0].shading == cards[1].shading) && (cards[1].shading == cards[2].shading) && (cards[2].shading == cards[0].shading) ||
            (cards[0].shading != cards[1].shading) && (cards[1].shading != cards[2].shading) && (cards[2].shading != cards[0].shading) {
            shadingMatched = true
        }
        
        return symbolMatched && numberMatched && colorMatched && shadingMatched
    }
    
    mutating func select(card: Card) {
        if selectedCards.count == 3 {
            deal3MoreCard()
        }
        
        if !selectedCards.contains(card) {
            selectedCards.append(card)
        } else {
            selectedCards.remove(at: selectedCards.index(of: card)!)
        }

    }
    
    mutating func deal3MoreCard() {
        let numOfPossibleSet = possibleSet().count
        if selectedCards.count == 3 {
            if isMatched(for: selectedCards) {
                point += 100/numOfPossibleSet
                collectedSets += 1
                for index in selectedCards.indices {
                    if let index = cardsOnBoard.index(of: selectedCards[index]) {
                        if cardsOnBoard.count <= 12 {
                            if let card = draw() {
                                cardsOnBoard[index] = card
                            } else {
                                cardsOnBoard.remove(at: index)
                            }
                        } else {
                            cardsOnBoard.remove(at: index)
                        }
                    }
                }
            } else {
                point -= 50
            }
            selectedCards.removeAll()
        } else if cardsOnBoard.count <= 21 {
            if numOfPossibleSet > 0 {
                point -= numOfPossibleSet*50
            }
            for _ in 0..<3 {
                if let card = draw() {
                    cardsOnBoard.append(card)
                }
            }
        }
    }

    mutating func shuffleCardsOnBoard() {
        var lastIndex = cardsOnBoard.count - 1
        while(lastIndex > 0) {
            let rand = Int(arc4random_uniform(UInt32(lastIndex)))
            cardsOnBoard.swapAt(lastIndex, rand)
            lastIndex -= 1
        }
    }
    
    func possibleSet() -> [Set<Int>] {
        var counter = [Set<Int>]()
        
        for card1 in cardsOnBoard {
            for card2 in cardsOnBoard{
                for card3 in cardsOnBoard{
                    if card1 != card2 && card1 != card3 && card2 != card3 && isMatched(for: [card1,card2,card3]){
                        if !counter.contains([cardsOnBoard.index(of: card1)!,cardsOnBoard.index(of: card2)!,cardsOnBoard.index(of: card3)!]) {
                            counter.append([cardsOnBoard.index(of: card1)!,cardsOnBoard.index(of: card2)!,cardsOnBoard.index(of: card3)!])
                        }
                    }
                }
            }
        }
        return counter
    }
    
    mutating func calculateDurationOfLastSet() {
        let durationOfLastSet = Date().timeIntervalSince(date)
        date = Date()
        print(durationOfLastSet)
        if durationOfLastSet < 20 {
            point += Int(25*(20-durationOfLastSet))
        }
    }
}
