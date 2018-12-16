//
//  CardView.swift
//  SetGame
//
//  Created by Mehrab on 02/06/2018.
//  Copyright © 2018 Mehrab. All rights reserved.
//

import UIKit


class CardView: UIButton {
    var number: Int = 2 { didSet {setNeedsDisplay()}}
    var symbol: String = "oval" { didSet {setNeedsDisplay()}}
    var shading: String = "striped" { didSet {setNeedsDisplay()}}
    var color: UIColor = .clear { didSet {setNeedsDisplay()}}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    var cardWidth: CGFloat {return bounds.size.width}
    var cardHeight: CGFloat {return bounds.size.height}
    var cardUnit: CGFloat {return  cardWidth/5}

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {

        let finalPath = UIBezierPath()
        applyNumber(finalPath: finalPath)
        color.setStroke()
        finalPath.stroke()
        finalPath.addClip()
        applyShading(path: finalPath)
        
        
    }
    
    func drawPath() -> UIBezierPath {
        switch symbol {
        case "diamond":
            return drawDiamond()
        case "squiggle":
            return drawSquiggle()
        case "oval":
            return drawOval()
        default:
            return UIBezierPath()
        }
    }
    
    func drawDiamond() -> UIBezierPath {
        let diamond = UIBezierPath()
        
        diamond.move(to: CGPoint(x: cardUnit, y: cardHeight/2))
        diamond.addLine(to: CGPoint(x: cardWidth/2, y: cardHeight/2 - cardUnit/2))
        diamond.addLine(to: CGPoint(x: cardWidth - cardUnit, y: cardHeight/2))
        diamond.addLine(to: CGPoint(x: cardWidth/2, y: cardHeight/2 + cardUnit/2))
        diamond.close()
        
        return diamond
    }
    
    func drawSquiggle() -> UIBezierPath {
        let squiggle = UIBezierPath()
        
        squiggle.move(to: CGPoint(x: 1.5*cardUnit, y: cardHeight/2 - cardUnit/2))
        squiggle.addCurve(to: CGPoint(x: cardWidth - 1.5*cardUnit, y: cardHeight/2 - cardUnit/2),
                          controlPoint1: CGPoint(x: 2 * cardUnit, y: cardHeight/2 - cardUnit),
                          controlPoint2: CGPoint(x: 3 * cardUnit, y: cardHeight/2))
        
        squiggle.addCurve(to: CGPoint(x: cardWidth - 1.5*cardUnit, y: cardHeight/2 + cardUnit/2),
                          controlPoint1: CGPoint(x: cardWidth - cardUnit, y: cardHeight/2 - cardUnit),
                          controlPoint2: CGPoint(x: cardWidth - cardUnit, y: cardHeight/2))
        
        squiggle.addCurve(to: CGPoint(x: 1.5*cardUnit, y: cardHeight/2 + cardUnit/2),
                          controlPoint1: CGPoint(x: 3 * cardUnit, y: cardHeight/2 + cardUnit),
                          controlPoint2: CGPoint(x: 2 * cardUnit, y: cardHeight/2))
        
        squiggle.addCurve(to: CGPoint(x: 1.5*cardUnit, y: cardHeight/2 - cardUnit/2),
                          controlPoint1: CGPoint(x: cardUnit, y: cardHeight/2 + cardUnit),
                          controlPoint2: CGPoint(x: cardUnit, y: cardHeight/2))
        squiggle.close()
        return squiggle
    }
    
    func drawOval() -> UIBezierPath {
        let oval = UIBezierPath(roundedRect: CGRect(x: cardUnit, y: cardHeight/2 - cardUnit/2, width: 3*cardUnit, height: cardUnit), cornerRadius: cardUnit)

        return oval
    }



    
    func applyShading(path: UIBezierPath) {
        if (shading == "solid") {
            color.setFill()
            path.fill()
        } else if (shading == "striped") {
            let bars = UIBezierPath()
            for x in stride(from: 0, to: cardWidth, by: cardUnit/3) {
                bars.move(to: CGPoint(x: x, y: 0))
                bars.addLine(to: CGPoint(x: x, y: cardHeight))
            }
            bars.close()
            color.setStroke()
            bars.stroke()

        }
    }
    
    func applyNumber(finalPath: UIBezierPath) {
        if number == 3 {
            let path1 = drawPath()
            path1.apply(CGAffineTransform(translationX: 0, y: -2*cardUnit))
            let path2 = drawPath()
            let path3 = drawPath()
            path3.apply(CGAffineTransform(translationX: 0, y: 2*cardUnit))
            finalPath.append(path1)
            finalPath.append(path2)
            finalPath.append(path3)
        } else if number == 2{
            let path1 = drawPath()
            path1.apply(CGAffineTransform(translationX: 0, y: -cardUnit))
            let path2 = drawPath()
            path2.apply(CGAffineTransform(translationX: 0, y: cardUnit))
            finalPath.append(path1)
            finalPath.append(path2)
        } else {
            let path1 = drawPath()
            finalPath.append(path1)
        }
    }

}
