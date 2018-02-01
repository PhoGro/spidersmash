//
//  Card.swift
//  PEMDAS
//
//  Created by John Davenport on 8/22/17.
//  Copyright © 2017 John Davenport. All rights reserved.
//

import SpriteKit
import UIKit


class Card : SKSpriteNode {
    
    let cardType: CardType
    let frontTexture: SKTexture

    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(cardType: CardType) {
       
        self.cardType = cardType

        
        switch cardType {
        case .orange:
            frontTexture = SKTexture(imageNamed: "Orange")
        case .blue:
            frontTexture = SKTexture(imageNamed: "Blue")
        case .yellow:
            frontTexture = SKTexture(imageNamed: "Yellow")
        case .green:
            frontTexture = SKTexture(imageNamed: "Green")
        case .purple:
            frontTexture = SKTexture(imageNamed: "Purple")
        }
    
        super.init(texture: frontTexture, color: .clear, size: frontTexture.size())
        

    }
    
}

