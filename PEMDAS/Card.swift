//
//  Card.swift
//  PEMDAS
//
//  Created by John Davenport on 8/22/17.
//  Copyright © 2017 John Davenport. All rights reserved.
//

import SpriteKit
import UIKit

//resource generator
public var lightPoints = 0

//cost to play
public var darkPoints = 0



//card properties (health, attack, damage, effects
public var attackPoints = 0
public var healthPoints = 0
public var directDamage = 0
public var damageOverTime = 0
public var dotTurns = 0

//name of card
public var cardName = ""

//
public var spell = false
public var creature = false

class Card : SKSpriteNode {
    
    let cardType: CardType
    let damageLabel: SKLabelNode
    let nameLabel: SKLabelNode
    let lightPointLabel: SKLabelNode
    let darkPointsLabel: SKLabelNode
    let descriptionText: SKLabelNode
    let frontTexture: SKTexture
    let backTexture: SKTexture
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(cardType: CardType) {
       
        self.cardType = cardType
        backTexture = SKTexture(imageNamed: "card_back")
        damageLabel = SKLabelNode()
        lightPointLabel = SKLabelNode()
        darkPointsLabel = SKLabelNode()
        descriptionText = SKLabelNode()
        nameLabel = SKLabelNode()

        
        switch cardType {
        case .lightCard:
            frontTexture = SKTexture(imageNamed: "lightCard")
        case .darkCard:
            frontTexture = SKTexture(imageNamed: "darkCard")
        case .creatureCard:
            frontTexture = SKTexture(imageNamed: "creatureCard")
        case .eventCard:
            frontTexture = SKTexture(imageNamed: "eventCard")
        }
        
        //card name
        nameLabel.text = "\(cardName)"
        
        if spell == true {
        // direct spell damage
        damageLabel.text = "\(directDamage)"
            
        
        }
        
        if creature == true {
        //attack of creature card
        damageLabel.text = "\(attackPoints)"
        
        }
        
        //resource/cost display
        if lightPoints > 0 {
        lightPointLabel.text = "\(lightPoints)"
        } else if lightPoints == 0 {
        lightPointLabel.text = ""
        }
        
        if darkPoints > 0 {
        darkPointsLabel.text = "\(darkPoints)"
        } else if darkPoints == 0 {
        darkPointsLabel.text = ""
        }
        
        //label positions and styles
        //display name of card
        nameLabel.name = "nameLabel"
        nameLabel.fontName = "Helvetica-Bold"
        nameLabel.fontSize = 12
        nameLabel.fontColor = .black
        nameLabel.zPosition = 2
        nameLabel.position = CGPoint(x: 0.5, y: 5)
        
        
        //displays damage of card (either direct damage for spell or attack power of creature)
        damageLabel.name = "damageLabel"
        damageLabel.fontName = "Helvetica-Bold"
        damageLabel.fontSize = 12
        damageLabel.fontColor = .black
        damageLabel.zPosition = 2
        damageLabel.position = CGPoint(x: -30, y: -45)
        
        //displays light points card will generorate
        lightPointLabel.name = "lightPointsLabel"
        lightPointLabel.fontName = "Helvetica-Bold"
        lightPointLabel.fontSize = 16
        lightPointLabel.fontColor = .black
        lightPointLabel.zPosition = 2
        lightPointLabel.position = CGPoint(x: -30, y: 35)
        
        //displays dark points required to play
        darkPointsLabel.name = "darkPointsLabel"
        darkPointsLabel.fontName = "Helvetica-Bold"
        darkPointsLabel.fontSize = 16
        darkPointsLabel.fontColor = .black
        darkPointsLabel.zPosition = 2
        darkPointsLabel.position = CGPoint(x: 30, y: 35)
    
        super.init(texture: frontTexture, color: .clear, size: frontTexture.size())
        
        //add labels to card
        addChild(lightPointLabel)
        addChild(darkPointsLabel)
        addChild(damageLabel)
        addChild(nameLabel)

    }
    
    
    
    
    
    
    
}

