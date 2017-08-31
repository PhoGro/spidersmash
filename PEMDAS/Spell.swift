//
//  Spell.swift
//  PEMDAS
//
//  Created by John Davenport on 8/29/17.
//  Copyright © 2017 John Davenport. All rights reserved.
//

import SpriteKit
import UIKit



class SpellCard: Card {
    
    let spellCardNames: SpellCardNames
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(cardType: CardType, spellCardNames: SpellCardNames) {
        
        self.spellCardNames = spellCardNames
        
        // different spell cards
        switch spellCardNames {
        case .lightWell:
            lightPoints = 5
            darkPoints = 0
            directDamage = 2
            dotTurns = 3
            cardName = "LightWell"
        case .darkMatter:
            lightPoints = 0
            darkPoints = 10
            directDamage = 4
            cardName = "Dark Matter"
        case .solarWinds:
            lightPoints = 5
            darkPoints = 0
            directDamage = 8
            cardName = "Solar Winds"
        }
        
        spell = true
        
        super.init(cardType: cardType)
        
        
    }
    
    
}
