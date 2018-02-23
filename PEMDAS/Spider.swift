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
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(spiderType: SpiderType) {
       
        self.spiderType = spiderType
        
        switch spiderType {
        case .orangeSpider:
            frontTexture = SKTexture(imageNamed: "OrangeSpider")
            spiderMaxHealth = 2
        case .blueSpider:
            frontTexture = SKTexture(imageNamed: "BlueSpider")
            spiderMaxHealth = 2
        case .yellowSpider:
            frontTexture = SKTexture(imageNamed: "YellowSpider")
            spiderMaxHealth = 2
        case .greenSpider:
            frontTexture = SKTexture(imageNamed: "GreenSpider")
            spiderMaxHealth = 2
        case .purpleSpider:
            frontTexture = SKTexture(imageNamed: "PurpleSpider")
            spiderMaxHealth = 2
        }
        
    
        
        
        super.init(texture: frontTexture, color: .clear, size: frontTexture.size())
        
        

    }
    
}
