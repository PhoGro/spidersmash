//
//  Card.swift
//  PEMDAS
//
//  Created by John Davenport on 8/22/17.
//  Copyright © 2017 John Davenport. All rights reserved.
//

import SpriteKit


enum BuffType {
    case increaseAttack,
    increaseHealth,
    healToFull,
    pointsMultiplier
}

class Buffs : SKSpriteNode {
    
    let buffType: BuffType
    let frontTexture: SKTexture
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(buffType: BuffType) {
        
        self.buffType = buffType
        
        
        switch buffType {
        case .increaseAttack:
            frontTexture = SKTexture(imageNamed: "IncreaseAttack")
        case .increaseHealth:
            frontTexture = SKTexture(imageNamed: "IncreaseHealth")
        case .healToFull:
            frontTexture = SKTexture(imageNamed: "RestoreHealth")
        case .pointsMultiplier:
            frontTexture = SKTexture(imageNamed: "PointsMultiplier")
        }
        
        super.init(texture: frontTexture, color: .clear, size: frontTexture.size())
        
        
    }
    
    
    
    
}
