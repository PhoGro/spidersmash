//
//  Card.swift
//  PEMDAS
//
//  Created by John Davenport on 8/22/17.
//  Copyright © 2017 John Davenport. All rights reserved.
//

import SpriteKit

enum ActiveHammers {
    case yellowRight, yellowUp, yellowDown, yellowLeft,
    blueUp, blueDown, blueRight, blueLeft,
    greenUp, greenDown, greenRight, greenLeft,
    orangeUp, orangeDown, orangeRight, orangeLeft,
    purpleUp, purpleDown, purpleRight, purpleLeft
}


class ActiveHammer : SKSpriteNode {
    
    let activeHammer: ActiveHammers
    let frontTexture: SKTexture
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(activeHammer: ActiveHammers) {
       
        self.activeHammer = activeHammer

        
        switch activeHammer {
        case .greenUp:
            frontTexture = SKTexture(imageNamed: "Orange")
        case .greenDown:
            frontTexture = SKTexture(imageNamed: "Blue")
        case .greenLeft:
            frontTexture = SKTexture(imageNamed: "Yellow")
        case .greenRight:
            frontTexture = SKTexture(imageNamed: "Green")
        case .blueUp:
            frontTexture = SKTexture(imageNamed: "Orange")
        case .blueDown:
            frontTexture = SKTexture(imageNamed: "Blue")
        case .blueLeft:
            frontTexture = SKTexture(imageNamed: "defaultHammerLeft")
        case .blueRight:
            frontTexture = SKTexture(imageNamed: "defaultHammerRight")
        case .purpleUp:
            frontTexture = SKTexture(imageNamed: "Orange")
        case .purpleDown:
            frontTexture = SKTexture(imageNamed: "Blue")
        case .purpleLeft:
            frontTexture = SKTexture(imageNamed: "Yellow")
        case .purpleRight:
            frontTexture = SKTexture(imageNamed: "Green")
        case .orangeUp:
            frontTexture = SKTexture(imageNamed: "Orange")
        case .orangeDown:
            frontTexture = SKTexture(imageNamed: "Blue")
        case .orangeLeft:
            frontTexture = SKTexture(imageNamed: "Yellow")
        case .orangeRight:
            frontTexture = SKTexture(imageNamed: "Green")
        case .yellowUp:
            frontTexture = SKTexture(imageNamed: "defaultHammerUp")
        case .yellowDown:
            frontTexture = SKTexture(imageNamed: "defaultHammerDown")
        case .yellowLeft:
            frontTexture = SKTexture(imageNamed: "Yellow")
        case .yellowRight:
            frontTexture = SKTexture(imageNamed: "Green")
        
        }
    
        super.init(texture: frontTexture, color: .clear, size: frontTexture.size())
        

    }
    
}

