//
//  Structs.swift
//  PEMDAS
//
//  Created by John Davenport on 2/24/18.
//  Copyright © 2018 John Davenport. All rights reserved.
//

import Foundation

/*
 
 projectile - 1
 spiders - 3
 level exit - 3
 heart - 3
 player - 4
 hammer - 4
 wall - 5
 
 
 
 */

struct PhysicsCategory {
    static let None : UInt32 = 0
    static let Projectile : UInt32 = 1 << 1
    static let Spider : UInt32 = 1 << 3
    static let LevelExit : UInt32 = 1 << 3
    static let Heart : UInt32 = 1 << 3
    static let Player : UInt32 = 1 << 5
    static let Hammer : UInt32 = 1 << 6
    static let Wall : UInt32 = 1 << 7
}

enum ContactType{
    case SpiderHitPlayer
    case PlayerHitSpider
    case PlayerGetHearts
    case SpiderProjectileHitsPlayer
    case SpiderProjectileHitsWall
    case PlayerExitsLevel
    case none
}

