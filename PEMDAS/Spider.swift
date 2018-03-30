//
//  Card.swift
//  PEMDAS
//
//  Created by John Davenport on 8/22/17.
//  Copyright © 2017 John Davenport. All rights reserved.
//

import SpriteKit

enum SpiderType {
    case orangeSpider
    case yellowSpider
    case greenSpider
    case blueSpider
    case purpleSpider
}


class Spider : SKSpriteNode {
    
    let spiderType: SpiderType
    let frontTexture: SKTexture
    var spiderHealth: Int = 0
    var spiderMaxHealth: Int = 0
    var spiderAttacking: Bool = false
    var spiderCoolDown: Bool = false
    var spiderCoolDownStarted: Bool = false
    var spiderCoolDownCounter: Int = 5
    var spiderAction: String = ""
    var moving: Bool = false
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(spiderType: SpiderType) {
       
        self.spiderType = spiderType
        
        switch spiderType {
        case .orangeSpider:
            frontTexture = SKTexture(imageNamed: "OrangeSpider")
            spiderMaxHealth = 8
            spiderHealth = 8
            spiderAttacking = false
            spiderCoolDown = false
            spiderCoolDownStarted = false
        case .blueSpider:
            frontTexture = SKTexture(imageNamed: "BlueSpider")
            spiderMaxHealth = 6
            spiderHealth = 6
            spiderAttacking = false
            spiderCoolDown = false
            spiderCoolDownStarted = false
        case .yellowSpider:
            frontTexture = SKTexture(imageNamed: "YellowSpider")
            spiderMaxHealth = 4
            spiderHealth = 4
            spiderAttacking = false
            spiderCoolDown = false
            spiderCoolDownStarted = false
        case .greenSpider:
            frontTexture = SKTexture(imageNamed: "GreenSpider")
            spiderMaxHealth = 5
            spiderHealth = 5
            spiderAttacking = false
            spiderCoolDown = false
            spiderCoolDownStarted = false
        case .purpleSpider:
            frontTexture = SKTexture(imageNamed: "PurpleSpider")
            spiderMaxHealth = 4
            spiderHealth = 4
            spiderAttacking = false
            spiderCoolDown = false
            spiderCoolDownStarted = false
        }
        
    
        
        
        super.init(texture: frontTexture, color: .clear, size: frontTexture.size())
        
        

    }
    
}
