//
//  Card.swift
//  PEMDAS
//
//  Created by John Davenport on 8/22/17.
//  Copyright © 2017 John Davenport. All rights reserved.
//

import SpriteKit
import UIKit


class Spider : SKSpriteNode {
    
    let spiderType: SpiderType
    let frontTexture: SKTexture
    public var spiderHealth: Int
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(spiderType: SpiderType) {
       
        self.spiderType = spiderType
        
        switch spiderType {
        case .orangeSpider:
            frontTexture = SKTexture(imageNamed: "OrangeSpider")
            spiderHealth = 2
        case .blueSpider:
            frontTexture = SKTexture(imageNamed: "BlueSpider")
            spiderHealth = 2
        case .yellowSpider:
            frontTexture = SKTexture(imageNamed: "YellowSpider")
            spiderHealth = 2
        case .greenSpider:
            frontTexture = SKTexture(imageNamed: "GreenSpider")
            spiderHealth = 2
        case .purpleSpider:
            frontTexture = SKTexture(imageNamed: "PurpleSpider")
            spiderHealth = 2
        }
        
    
        super.init(texture: frontTexture, color: .clear, size: frontTexture.size())
        
        

    }
    
}
