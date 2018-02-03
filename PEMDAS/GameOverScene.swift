//
//  GameOver.swift
//  PEMDAS
//
//  Created by John Davenport on 12/20/17.
//  Copyright © 2017 John Davenport. All rights reserved.
//

import Foundation
import SpriteKit
class GameOverScene: SKScene {
    
    var scoreLabel: SKLabelNode?
    var highScoreLabel: SKLabelNode?
    var gameOverLabel: SKLabelNode?
    let background = SKSpriteNode(imageNamed: "background")
    var score = 0
    
    override func didMove(to view: SKView) {
        
        scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        score =  self.userData?.value(forKey: "score") as! Int
        
        //Set the background
        background.size = frame.size
        background.zPosition = -1
        background.position = CGPoint(x: 0.5, y: 0.5)
        addChild(background)
        
        //Initialize ScoreLabel
        gameOverLabel = SKLabelNode()
        gameOverLabel?.fontColor = SKColor.red
        gameOverLabel?.fontSize = 50
        gameOverLabel?.fontName = "AvenirNext-Bold"
        gameOverLabel?.text = "GAME OVER!"
        gameOverLabel?.position = CGPoint(x: 0, y: 100)
        addChild(gameOverLabel!)
        
        //Initialize ScoreLabel
        scoreLabel = SKLabelNode()
        scoreLabel?.fontColor = SKColor.white
        scoreLabel?.fontSize = 30
        scoreLabel?.fontName = "AvenirNext-Bold"
        scoreLabel?.text = "Score: \(score)"
        scoreLabel?.position = CGPoint(x: 0, y: 0)
        addChild(scoreLabel!)
        
        //set highscorelabe
        highScoreLabel = SKLabelNode()
        highScoreLabel?.text = "High Score = \(UserDefaults().integer(forKey: "HIGHSCORE"))"
        highScoreLabel?.fontColor = SKColor.white
        highScoreLabel?.fontName = "AvenirNext-Bold"
        highScoreLabel?.fontSize = 30
        highScoreLabel?.position = CGPoint(x: 0, y: -120)
        addChild(highScoreLabel!)
        
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let transition = SKTransition.flipVertical(withDuration: 0.5)
        if let mainMenu = SKScene(fileNamed: "MainMenu") {

        mainMenu.userData = NSMutableDictionary()
        mainMenu.scaleMode = .aspectFill
            
        view?.presentScene(mainMenu, transition: transition)
        
        }
        
    }

}
