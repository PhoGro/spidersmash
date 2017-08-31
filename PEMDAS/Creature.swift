//
//  Creature.swift
//  PEMDAS
//
//  Created by John Davenport on 8/29/17.
//  Copyright © 2017 John Davenport. All rights reserved.
//

import SpriteKit
import UIKit



class CreatureCard: Card {
    
    let creatureCardNames: CreatureCardNames
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(cardType: CardType, creatureCardNames: CreatureCardNames) {
        
        self.creatureCardNames = creatureCardNames
        
        
        // different creature cards
        switch creatureCardNames {
        case .nightOwl:
            lightPoints = 0
            darkPoints = 3
            attackPoints = 4
            healthPoints = 5
            cardName = "Night Owl"            
        case .vampireBat:
            lightPoints = 0
            darkPoints = 3
            attackPoints = 2
            healthPoints = 3
            cardName = "Vampire Bat"
        case .arcticWolf:
            lightPoints = 5
            darkPoints = 0
            attackPoints = 3
            healthPoints = 8
            cardName = "Arctic Wolf"
        }
        
        creature = true
        
        super.init(cardType: cardType)
        
        
    }
    
    
}
