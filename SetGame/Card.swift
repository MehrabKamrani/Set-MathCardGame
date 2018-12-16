//
//  SetCard.swift
//  SetGame
//
//  Created by Mehrab on 19/05/2018.
//  Copyright © 2018 Mehrab. All rights reserved.
//

import Foundation

struct Card: Equatable {
    
    var number: Number
    var symbol: Symbol
    var shading: Shading
    var color: Color

    init(number: Number, symbol: Symbol, shading: Shading, color: Color) {
        self.number = number
        self.symbol = symbol
        self.shading = shading
        self.color = color
    }
    
    enum Number {
        case one, two, three
        static var all = [.one, two, three]
    }
    
    enum Symbol {
        case diamond, squiggle, oval
        static var all = [.diamond, squiggle, oval]
    }
    
    enum Shading {
        case solid, striped, open
        static var all = [.solid, striped, open]
    }
    
    enum Color {
        case red, green, purple
        static var all = [.red, green, purple]
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return
            lhs.number == rhs.number &&
            lhs.symbol == rhs.symbol &&
            lhs.shading == rhs.shading &&
            lhs.color == rhs.color
    }
}
