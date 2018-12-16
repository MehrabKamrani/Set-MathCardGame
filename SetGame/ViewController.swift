    //
//  ViewController.swift
//  SetGame
//
//  Created by Mehrab on 19/05/2018.
//  Copyright © 2018 Mehrab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var game = SetGame()
    
    @IBOutlet weak var cardContainerStackView: UIStackView!
    
    @IBOutlet var cardButtonCollection: [UIButton]!
    @IBOutlet weak var deal3MoreCardsButton: UIButton!
    
    @IBOutlet weak var numberOfSetsLabel: UILabel!
    @IBOutlet weak var remainingCardsLabel: UILabel!
    
    @IBOutlet weak var pointLabel: UILabel!
    
//    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//        if UIDevice.current.orientation.isLandscape {
//            cardContainerStackView.transform = CGAffineTransform(rotationAngle: -.pi/2).scaledBy(x: 3, y: 3)
//        } else {
//            cardContainerStackView.transform = CGAffineTransform.identity
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.startGame()
        print(game.possibleSet())
    }
    
    override func viewDidLayoutSubviews() {
        updateUI()
        print(cardButtonCollection.count)
    }
    
    
    func apply(cardView: CardView ,for card: Card) {
        
        switch card.symbol {
        case .diamond:
            cardView.symbol = "diamond"
        case .squiggle:
            cardView.symbol = "squiggle"
        case .oval:
            cardView.symbol = "oval"
        }

        switch card.number {
        case .one:
            cardView.number = 1
        case .two:
            cardView.number = 2
        case .three:
            cardView.number = 3
        }
        
        switch card.color {
        case .green:
            cardView.color = .green
        case .red:
            cardView.color = .red
        case .purple:
            cardView.color = .purple
        }
        
        switch card.shading {
        case .solid:
            cardView.shading = "solid"
        case .striped:
            cardView.shading = "striped"
        case .open:
            cardView.shading = "open"
        }

    }
    

    @IBAction func cardSelected(_ sender: UIButton) {
        guard let index = cardButtonCollection.index(of: sender) else { return }

        game.select(card: game.cardsOnBoard[index])
        updateUI()
        
    }
    
    func updateUI() {
        
        numberOfSetsLabel.text = "Sets: \(game.collectedSets)"
        remainingCardsLabel.text = "Remaining Cards: \(game.deck.count)"
        pointLabel.text = "\(game.point)"

        
        for index in cardButtonCollection.indices {
            cardButtonCollection[index].isEnabled = false
            cardButtonCollection[index].setAttributedTitle(nil, for: .normal)
            cardButtonCollection[index].layer.borderColor = UIColor.clear.cgColor
            let cardView = cardButtonCollection[index] as! CardView
            cardView.color = .clear
        }
        
        for index in game.cardsOnBoard.indices {
            cardButtonCollection[index].isEnabled = true
            cardButtonCollection[index].layer.cornerRadius = cardContainerStackView.frame.width/50
            cardButtonCollection[index].layer.borderWidth = cardContainerStackView.frame.width/250
            cardButtonCollection[index].layer.borderColor = UIColor.lightGray.cgColor
            let cardView = cardButtonCollection[index] as! CardView
            apply(cardView: cardView ,for: game.cardsOnBoard[index])
        }
        
        if game.cardsOnBoard.count == 24 || game.deck.count == 0 {
            deal3MoreCardsButton.isEnabled = false
        } else {
            deal3MoreCardsButton.isEnabled = true
        }
        
        if game.selectedCards.count < 3 {
            changeBorderColor(to: .black)
        } else {
            if game.isMatched(for: game.selectedCards) {
                game.calculateDurationOfLastSet()
                changeBorderColor(to: .green)
                deal3MoreCardsButton.isEnabled = true
            } else {
                changeBorderColor(to: .red)
            }
        }
        

        
    }
    
    func changeBorderColor(to color: UIColor) {
        for index in game.selectedCards.indices {
            if let index = game.cardsOnBoard.index(of: game.selectedCards[index]) {
                cardButtonCollection[index].layer.borderWidth = cardContainerStackView.frame.width/250
                cardButtonCollection[index].layer.borderColor = color.cgColor
            }
        }
    }
    
    @IBAction func deal3MoreCards(_ sender: UIButton) {
        game.deal3MoreCard()
        updateUI()
        print(game.possibleSet())
    }
    
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        game.deal3MoreCard()
        updateUI()
        print(game.possibleSet())
    }
    @IBAction func rotationGesture(_ sender: UIRotationGestureRecognizer) {
        game.shuffleCardsOnBoard()
        updateUI()
    }
    
    @IBAction func generateNewGame(_ sender: UIButton) {
        game = SetGame()
        game.startGame()
        updateUI()
    }
    
}

