//
//  SceneLoadManager.swift
//  PEMDAS
//
//  Created by John Davenport on 2/1/18.
//  Copyright © 2018 John Davenport. All rights reserved.
//

import UIKit
import SpriteKit

enum SceneIdentifier: String {
    case LevelOne = "LevelOne"
    case levelTwo = "LevelTwo"
    case levelThree = "LevelThree"
    case gameOverScene = "GameOverScene"
    case levelEnd = "LevelEnd"
    case levelTransition = "LevelTransition"
}

private let sceneSize = CGSize(width: 768, height: 1024)

protocol SceneManager { }
extension SceneManager where Self: SKScene {
    
    func loadScene(withIdentifier identifier: SceneIdentifier, currentScore: Int, currentTime: Int, currentPlayerHealth: Double, spidersSmashed: Int, waveLevel: Int, playerMaxDamage: Int, playerMinDamage: Int, playerMaxHealth: Double, playerMultipler: Int, spiderDamageMultiplier: Double) {
        
        let points = currentScore
        let levelTimerValue = currentTime
        let playerHealth = currentPlayerHealth
        let spidersSmashed = spidersSmashed
        let playerDMGMultiplier = playerMultipler
        let playerMaxDamage = playerMaxDamage
        let playerMinDamage = playerMinDamage
        let playerMaxHealth = playerMaxHealth
        let spiderDamageMultiplier = spiderDamageMultiplier
        
        let reveal = SKTransition.crossFade(withDuration: 0.25)
        let nextLevel = SKScene(fileNamed: identifier.rawValue)
        nextLevel?.userData = NSMutableDictionary()
        nextLevel?.userData?.setObject(points, forKey: "score" as NSCopying)
        nextLevel?.userData?.setObject(levelTimerValue, forKey: "LTV" as NSCopying)
        nextLevel?.userData?.setObject(playerHealth, forKey: "playerHealth" as NSCopying)
        nextLevel?.userData?.setObject(spidersSmashed, forKey: "spidersSmashed" as NSCopying)
        nextLevel?.userData?.setObject(waveLevel, forKey: "waveLevel" as NSCopying)
        nextLevel?.userData?.setObject(playerMaxDamage, forKey: "playerMaxDamage" as NSCopying)
        nextLevel?.userData?.setObject(playerMinDamage, forKey: "playerMinDamage" as NSCopying)
        nextLevel?.userData?.setObject(playerMaxHealth, forKey: "playerMaxHealth" as NSCopying)
        nextLevel?.userData?.setObject(playerDMGMultiplier, forKey: "playerDMGMultiply" as NSCopying)
        nextLevel?.userData?.setObject(spiderDamageMultiplier, forKey: "spiderDamageMultiplier" as NSCopying)
        nextLevel?.scaleMode = .resizeFill
        self.view?.presentScene(nextLevel!, transition: reveal)
        
    }
}

