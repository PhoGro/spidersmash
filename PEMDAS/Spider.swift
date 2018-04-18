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
    let spiderAtlas = SKTextureAtlas(named: "Spiders")
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(spiderType: SpiderType) {
       
        self.spiderType = spiderType
        
        switch spiderType {
        case .orangeSpider:
            frontTexture = spiderAtlas.textureNamed("OrangeSpider")
            spiderMaxHealth = 20
            spiderHealth = 20
            spiderAttacking = false
            spiderCoolDown = false
            spiderCoolDownStarted = false
        case .blueSpider:
            frontTexture = spiderAtlas.textureNamed("BlueSpider")
            spiderMaxHealth = 15
            spiderHealth = 15
            spiderAttacking = false
            spiderCoolDown = false
            spiderCoolDownStarted = false
        case .yellowSpider:
            frontTexture = spiderAtlas.textureNamed("YellowSpider")
            spiderMaxHealth = 15
            spiderHealth = 15
            spiderAttacking = false
            spiderCoolDown = false
            spiderCoolDownStarted = false
        case .greenSpider:
            frontTexture = spiderAtlas.textureNamed("GreenSpider")
            spiderMaxHealth = 10
            spiderHealth = 10
            spiderAttacking = false
            spiderCoolDown = false
            spiderCoolDownStarted = false
        case .purpleSpider:
            frontTexture = spiderAtlas.textureNamed("PurpleSpider")
            spiderMaxHealth = 10
            spiderHealth = 10
            spiderAttacking = false
            spiderCoolDown = false
            spiderCoolDownStarted = false
        }
        
    
        
        
        super.init(texture: frontTexture, color: .clear, size: frontTexture.size())
        
        

    }
    
}
