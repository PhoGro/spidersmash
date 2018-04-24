//
//  GameOver.swift
//  PEMDAS
//
//  Created by John Davenport on 12/20/17.
//  Copyright © 2017 John Davenport. All rights reserved.
//

import Foundation
import SpriteKit
class LevelEnd: LevelOne {
    
    var scoreLabel: SKLabelNode?
    var playerScore: SKLabelNode?
    var finalHighScore: SKLabelNode?
    var spidersSmashed: SKLabelNode?
    var timeTaken: SKLabelNode?
    
    //var highScoreLabel: SKLabelNode?
    var gameOverLabel: SKLabelNode?
    let background = SKSpriteNode(imageNamed: "background")
    
    override func didMove(to view: SKView) {
        
        scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        displayScores()
        
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        let touch = touches.first!
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
        
        if ((node as? SKSpriteNode) != nil) && (node.name?.contains("restartGame") == true) {
        restartGame()
        
        let transition = SKTransition.flipVertical(withDuration: 0.5)
        if let mainMenu = SKScene(fileNamed: "MainMenu") {

        mainMenu.userData = NSMutableDictionary()
        mainMenu.scaleMode = .aspectFill
            
        view?.presentScene(mainMenu, transition: transition)
        
        }
        }
        
    }
    
    func displayScores() {
        
        score =  self.userData?.value(forKey: "score") as! Int
        timeElapsed = self.userData?.value(forKey: "LTV") as! Int
        spidersSmashedCount = self.userData?.value(forKey: "spidersSmashed") as! Int
        playerHealth = self.userData?.value(forKey: "playerHealth") as! Double
        
        
        finalScore = (score * spidersSmashedCount)
        
        if finalScore > UserDefaults().integer(forKey: "HIGHSCORE") {
            saveHighScore()
        }
        
        spidersSmashed = childNode(withName: "spidersSmashed") as? SKLabelNode
        spidersSmashed?.text = "\(spidersSmashedCount)"
        
        playerScore = (childNode(withName: "playerScore") as? SKLabelNode)!
        playerScore?.text = "\(finalScore)"
        
        finalHighScore = childNode(withName: "currentHighscore") as? SKLabelNode
        finalHighScore?.text = "\(UserDefaults().integer(forKey: "HIGHSCORE"))"
        
        timeTaken = childNode(withName: "timeTaken") as? SKLabelNode
        timeTaken?.text = "\(timeElapsed)"
    
    }

}
