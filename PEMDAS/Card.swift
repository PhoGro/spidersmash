//
//  Card.swift
//  PEMDAS
//
//  Created by John Davenport on 8/22/17.
//  Copyright © 2017 John Davenport. All rights reserved.
//

import SpriteKit

enum HammerType {
    case orange, // #f8941e
    yellow, // #f9f734
    green, // #0ef929
    blue, // #4d83f2
    purple // #a94df7
}

enum contactType {
    case playerAttackSpider,
    playerGetsHeart,
    playerExitsLevel,
    spiderAttacksPlayer,
    spiderProjectileHitsPlayer,
    spiderProjectileHitsWall
}


class Hammer : SKSpriteNode {
    
    let hammerType: HammerType
    let frontTexture: SKTexture
    let activeHammer: SKTexture

    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(hammerType: HammerType) {
       
        self.hammerType = hammerType

        
        switch hammerType {
        case .orange:
            frontTexture = SKTexture(imageNamed: "Orange")
            activeHammer = SKTexture(imageNamed: "defaultHammerRight")
        case .blue:
            frontTexture = SKTexture(imageNamed: "Blue")
            activeHammer = SKTexture(imageNamed: "defaultHammerRight")
        case .yellow:
            frontTexture = SKTexture(imageNamed: "Yellow")
            activeHammer = SKTexture(imageNamed: "defaultHammerRight")
        case .green:
            frontTexture = SKTexture(imageNamed: "Green")
            activeHammer = SKTexture(imageNamed: "greenHammerRight")
        case .purple:
            frontTexture = SKTexture(imageNamed: "Purple")
            activeHammer = SKTexture(imageNamed: "defaultHammerRight")
        }
    
        super.init(texture: frontTexture, color: .clear, size: frontTexture.size())
        

    }
    
}

