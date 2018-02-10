//
//  MainMenu.swift
//  PEMDAS
//
//  Created by John Davenport on 2/2/18.
//  Copyright © 2018 John Davenport. All rights reserved.
//

import Foundation
import SpriteKit
class MainMenu: SKScene, SceneManager {
    
    var gameTitle: SKLabelNode!
    var lvlSelected: SKSpriteNode?
    var nxtLvl = "LevelOne"
    
    override func didMove(to view: SKView) {
        
        nxtLvl = "LevelOne"
        scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //Set title
        gameTitle = childNode(withName: "gameTitle") as! SKLabelNode
        
        //Set Level Buttons
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let touch = touches.first!
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
        if ((node as? SKSpriteNode) != nil && node.name?.contains("startGame") == true) {
            
        print("Start Game")
        goTo(nextLevel: SceneIdentifier(rawValue: nxtLvl)!)
            
        }
        
        
//        let transition = SKTransition.flipVertical(withDuration: 0.5)
//        if let gameScene = SKScene(fileNamed: "GameScene") {
//            
//            gameScene.userData = NSMutableDictionary()
//            gameScene.scaleMode = .aspectFill
//            
//            view?.presentScene(gameScene, transition: transition)
//            
//        }
        
    }
    
    private func goTo(nextLevel: SceneIdentifier) {
        
        // pass key for next level which is passed from didMove to view of previous level
        print("loading scene for \(nxtLvl)")
//        loadScene(withIdentifier: SceneIdentifier(rawValue: nxtLvl)!)
        loadScene(withIdentifier: SceneIdentifier(rawValue: nxtLvl)!, currentScore: 0, currentTime: 0, currentPlayerHealth: 100)
    }
    
}
