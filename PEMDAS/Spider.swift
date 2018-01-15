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
    
    var spiderHealth = 2
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(spiderType: SpiderType) {
       
        self.spiderType = spiderType
        
        switch spiderType {
        case .orangeSpider:
            frontTexture = SKTexture(imageNamed: "OrangeSpider")
        case .blueSpider:
            frontTexture = SKTexture(imageNamed: "BlueSpider")
        case .yellowSpider:
            frontTexture = SKTexture(imageNamed: "YellowSpider")
        case .greenSpider:
            frontTexture = SKTexture(imageNamed: "GreenSpider")
        case .purpleSpider:
            frontTexture = SKTexture(imageNamed: "PurpleSpider")
        }
        
    
        super.init(texture: frontTexture, color: .clear, size: frontTexture.size())
        
        

    }
    
}

