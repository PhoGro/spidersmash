//
//  Card.swift
//  PEMDAS
//
//  Created by John Davenport on 8/22/17.
//  Copyright © 2017 John Davenport. All rights reserved.
//

import SpriteKit

enum BossType {
    case Zazu
    case Blub
    case Zapo
}


class Boss : SKSpriteNode {
    
    let bossType: BossType
    let frontTexture: SKTexture
    var bossHealth: Double = 0
    var bossMaxHealth: Double = 0
    var bossAttacking: Bool = false
    var bossCoolDown: Bool = false
    var bossCoolDownStarted: Bool = false
    var bossCoolDownCounter: Int = 5
    var bossAction: String = ""
    var moving: Bool = false
    let bossAtlas = SKTextureAtlas(named: "Boss")
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(bossType: BossType) {
       
        self.bossType = bossType
        
        switch bossType {
        
        case .Zazu:
            frontTexture = bossAtlas.textureNamed("Zazu")
            bossMaxHealth = 40
            bossHealth = 40
            bossAttacking = false
            bossCoolDown = false
            bossCoolDownStarted = false
        case .Blub:
            frontTexture = bossAtlas.textureNamed("Blub")
            bossMaxHealth = 50
            bossHealth = 50
            bossAttacking = false
            bossCoolDown = false
            bossCoolDownStarted = false
        case .Zapo:
            frontTexture = bossAtlas.textureNamed("Zapo")
            bossMaxHealth = 60
            bossHealth = 60
            bossAttacking = false
            bossCoolDown = false
            bossCoolDownStarted = false
            
        }
        
    
        
        
        super.init(texture: frontTexture, color: .clear, size: frontTexture.size())
        
    }
    
}
