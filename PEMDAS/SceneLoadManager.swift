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
}

private let sceneSize = CGSize(width: 768, height: 1024)

protocol SceneManager { }
extension SceneManager where Self: SKScene {
    
    func loadScene(withIdentifier identifier: SceneIdentifier, currentScore: Int, currentTime: Int, currentPlayerHealth: Double, spidersSmashed: Int) {
        
        let points = currentScore
        let levelTimerValue = currentTime
        let playerHealth = currentPlayerHealth
        let spidersSmashed = spidersSmashed
        
        let reveal = SKTransition.crossFade(withDuration: 0.25)
        let nextLevel = SKScene(fileNamed: identifier.rawValue)
        nextLevel?.userData = NSMutableDictionary()
        nextLevel?.userData?.setObject(points, forKey: "score" as NSCopying)
        nextLevel?.userData?.setObject(levelTimerValue, forKey: "LTV" as NSCopying)
        nextLevel?.userData?.setObject(playerHealth, forKey: "playerHealth" as NSCopying)
        nextLevel?.userData?.setObject(spidersSmashed, forKey: "spidersSmashed" as NSCopying)
        nextLevel?.scaleMode = .resizeFill
        self.view?.presentScene(nextLevel!, transition: reveal)
        
    }
}

