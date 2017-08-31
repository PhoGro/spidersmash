//
//  GameScene.swift
//  PEMDAS
//
//  Created by John Davenport on 8/16/17.
//  Copyright © 2017 John Davenport. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, Alerts {
    
    let posOne = CGPoint(x: -173, y: -137)
    let posTwo = CGPoint(x: -85, y: -137)
    let posThree = CGPoint(x: 1.6, y: -137)
    let posFour = CGPoint(x: 88, y: -137)
    let posFive = CGPoint(x: 173, y: -137)
    
    
    let dropZone = SKSpriteNode(imageNamed: "dropZone")
    
    var newCardPosition: Int?
    var playerHand = [CGPoint]()
    var playerCard: SKSpriteNode?
    var deck: [SKSpriteNode] = [SKSpriteNode()]
    
    var selectedNode: SKSpriteNode?
    var cardPosition: Int?
    var targetLabel: SKLabelNode?
    var lightPointsLabel: SKLabelNode?
    var movesLeftLabel: SKLabelNode?
    var movesLeft: Int = 10 {
        didSet {
            movesLeftLabel?.text = "Moves: \(movesLeft)"
        }
    }
    var lightPoints: Int = 15 {
        didSet {
            lightPointsLabel?.text = "LP: \(lightPoints)"
        }
    }
    var target: Int = Int(arc4random_uniform(50) + 100) {
        didSet {
            targetLabel?.text = "\(target)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        //Initialize Starting Hand
        
        startingHand()
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
       
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
        
        
        if (node.name == "cardOne") {
            // Step 1
            selectedNode = node as? SKSpriteNode
            
            if (selectedNode?.contains(posOne))! {
                cardPosition = 1
                print("CP1: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posTwo))! {
                cardPosition = 2
                print("CP2: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posThree))! {
                cardPosition = 3
                print("CP3: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posFour))! {
                cardPosition = 4
                print("CP4: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posFive))! {
                cardPosition = 5
                print("CP5: \(String(describing: cardPosition))")
            }
           
        }
        
        if (node.name == "cardTwo") {
            // Step 1
            selectedNode = node as? SKSpriteNode
            
            if (selectedNode?.contains(posOne))! {
                cardPosition = 1
                print("CP1: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posTwo))! {
                cardPosition = 2
                print("CP2: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posThree))! {
                cardPosition = 3
                print("CP3: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posFour))! {
                cardPosition = 4
                print("CP4: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posFive))! {
                cardPosition = 5
                print("CP5: \(String(describing: cardPosition))")
            }
            
        }
        if (node.name == "cardThree") {
            // Step 1
            selectedNode = node as? SKSpriteNode
            
            if (selectedNode?.contains(posOne))! {
                cardPosition = 1
                print("CP1: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posTwo))! {
                cardPosition = 2
                print("CP2: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posThree))! {
                cardPosition = 3
                print("CP3: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posFour))! {
                cardPosition = 4
                print("CP4: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posFive))! {
                cardPosition = 5
                print("CP5: \(String(describing: cardPosition))")
            }
            
        }
        if (node.name == "cardFour") {
            // Step 1
            selectedNode = node as? SKSpriteNode
            
            if (selectedNode?.contains(posOne))! {
                cardPosition = 1
                print("CP1: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posTwo))! {
                cardPosition = 2
                print("CP2: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posThree))! {
                cardPosition = 3
                print("CP3: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posFour))! {
                cardPosition = 4
                print("CP4: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posFive))! {
                cardPosition = 5
                print("CP5: \(String(describing: cardPosition))")
            }
            
        }
        if (node.name == "cardFive") {
            // Step 1
            selectedNode = node as? SKSpriteNode
            
            if (selectedNode?.contains(posOne))! {
                cardPosition = 1
                print("CP1: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posTwo))! {
                cardPosition = 2
                print("CP2: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posThree))! {
                cardPosition = 3
                print("CP3: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posFour))! {
                cardPosition = 4
                print("CP4: \(String(describing: cardPosition))")
            } else if (selectedNode?.contains(posFive))! {
                cardPosition = 5
                print("CP5: \(String(describing: cardPosition))")
            }
           
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
       
        
        if (selectedNode != nil) {
            // Step 1. update sprite's position
            selectedNode?.position = location
        }

    
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if selectedNode?.name == "cardOne" {
            cardPlayed()
        }
        if selectedNode?.name == "cardTwo"{
            cardPlayed()
        }
        if selectedNode?.name == "cardThree"{
            cardPlayed()
        }
        if selectedNode?.name == "cardFour"{
            cardPlayed()
        }
        if selectedNode?.name == "cardFive"{
            cardPlayed()
        }
        checkForWinLoss()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    
    }
    
    func createCard() -> SKSpriteNode {
        
        let cardOne = CreatureCard(cardType: .darkCard, creatureCardNames: .vampireBat)
        let cardTwo = CreatureCard(cardType: .darkCard, creatureCardNames: .nightOwl)
        let cardThree = SpellCard(cardType: .lightCard, spellCardNames: .lightWell)
        let cardFour = SpellCard(cardType: .lightCard, spellCardNames: .solarWinds)
        let cardFive = SpellCard(cardType: .darkCard, spellCardNames: .darkMatter)
        
        //Initialize Player's Hand
        cardOne.name = "cardOne"
        cardOne.physicsBody?.isDynamic = true
        cardOne.physicsBody?.affectedByGravity = false
        
        cardTwo.name = "cardTwo"
        cardTwo.physicsBody?.isDynamic = true
        cardTwo.physicsBody?.affectedByGravity = false
        
        cardThree.name = "cardThree"
        cardThree.physicsBody?.isDynamic = true
        cardThree.physicsBody?.affectedByGravity = false
        
        cardFour.name = "cardFour"
        cardFour.physicsBody?.isDynamic = true
        cardFour.physicsBody?.affectedByGravity = false
        
        cardFive.name = "cardFive"
        cardFive.physicsBody?.isDynamic = true
        cardFive.physicsBody?.affectedByGravity = false
        
        deck = [cardOne, cardTwo, cardThree, cardFour, cardFive]
        
        let randomCardNumber = Int(arc4random_uniform(UInt32(deck.count)))
        
        return deck[randomCardNumber]
        
    }
    
    func startingHand() {
        
        //Clear Board State
        removeAllChildren()
        
        playerHand = [posOne, posTwo, posThree, posFour, posFive]
        
        for item in playerHand {
            playerCard = createCard()
            playerCard?.position = item
            addChild(playerCard!)
        }
        
        
        // move below to new function for setting up game board
        //Initialize LightPoints
        lightPointsLabel = SKLabelNode()
        lightPointsLabel?.text = "LP: \(lightPoints)"
        lightPointsLabel?.position = CGPoint(x: -273, y: 150)
        addChild(lightPointsLabel!)
        
        //Initialize Moves Left
        movesLeftLabel = SKLabelNode()
        movesLeftLabel?.text = "Moves: \(movesLeft)"
        movesLeftLabel?.position = CGPoint(x: 260, y: 150)
        addChild(movesLeftLabel!)
        
        //Initialize Level Goal
        targetLabel = SKLabelNode()
        targetLabel?.text = "\(target)"
        targetLabel?.position = CGPoint(x: 1.6, y: 135)
        addChild(targetLabel!)
        
        //Initialize Dropzone
        dropZone.position = CGPoint(x: 0.5, y: 0.5)
        dropZone.zPosition = -1
        addChild(dropZone)
        
    }
    
   
    
    func cardPlayed() {
        
        if (selectedNode?.contains((dropZone.position)))! {
            print("drop zone")
            selectedNode?.removeFromParent()
            movesLeft -= 1
            performCardAction(cardPlayed: selectedNode!)
            reDraw(cardPosition: cardPosition!)
            
        } else if cardPosition == 1 {
            selectedNode?.position = posOne
        } else if cardPosition == 2 {
            selectedNode?.position = posTwo
        } else if cardPosition == 3 {
            selectedNode?.position = posThree
        } else if cardPosition == 4 {
            selectedNode?.position = posFour
        } else if cardPosition == 5 {
            selectedNode?.position = posFive
        }
        selectedNode = nil
        
    }
    
    func performCardAction(cardPlayed: SKSpriteNode) {
        
        /*
         
         This function determines the card's 
         actions to the board. It should handle
         all actions for playing cards.
         
         Account for
         
         1. Cost: LP and DP
         2. Damage: AttackP and Direct Damge
         3. Health: Creature Life
         4. Other: Any other effects
 
         August 30 2017 --
         
         currently not printing the right name or values for selected card.... need to dig deep and track the bug down.
         
         cardname.name
         cardname.lp
         cardname.dp
         cardname.dd
         cardname.hp
         cardname.dot
         
        */
        print("Name: \(cardName)")
        print("LP: \(lightPoints)")
        print("DP: \(darkPoints)")
        print("Damage: \(directDamage)")
        print("Health: \(healthPoints)")
        print("DOT: \(damageOverTime)")
        
        
        
        if cardPlayed.name == "cardOne" {
            print("card Name is: \(cardName)")
            targetLabel?.text = "\(target)"
        } else if cardPlayed.name == "cardTwo" {
            target -= 15
            lightPoints -= 10
            targetLabel?.text = "\(target)"
        } else if cardPlayed.name == "cardThree" {
            target += 7
            lightPoints += 12
            targetLabel?.text = "\(target)"
        } else if cardPlayed.name == "cardFour" {
            target = target / 2
            lightPoints -= 10
            targetLabel?.text = "\(target)"
        } else if cardPlayed.name == "cardFive" {
            target = target * 2
            lightPoints += 20
            targetLabel?.text = "\(target)"
        }
        
    }
    
    func reDraw(cardPosition: Int) {
        
        let randomCard = Int(arc4random_uniform(5)+1)
        var chosenCard = SKSpriteNode()
        print("\(randomCard)")
        
        //Select a Random Card
        if randomCard == 1 {
            chosenCard = createCard()
            chosenCard.name = "cardOne"
        }
        if randomCard == 2 {
            chosenCard = createCard()
            chosenCard.name = "cardTwo"
        }
        if randomCard == 3 {
            chosenCard = createCard()
            chosenCard.name = "cardThree"
        }
        if randomCard == 4 {
            chosenCard = createCard()
            chosenCard.name = "cardFour"
        }
        if randomCard == 5 {
            chosenCard = createCard()
            chosenCard.name = "cardFive"
        }
        
        //Determine which hand position needs to be replaced
        if cardPosition == 1 {
            chosenCard.position = posOne
            newCardPosition = 1
            addChild(chosenCard)
        } else if cardPosition == 2 {
            chosenCard.position = posTwo
            newCardPosition = 2
            addChild(chosenCard)
        } else if cardPosition == 3 {
            chosenCard.position = posThree
            newCardPosition = 3
            addChild(chosenCard)
        } else if cardPosition == 4 {
            chosenCard.position = posFour
            newCardPosition = 4
            addChild(chosenCard)
        } else if cardPosition == 5 {
            chosenCard.position = posFive
            newCardPosition = 5
            addChild(chosenCard)
        }
    }
    
    func checkForWinLoss() {
        
        if target <= 0 && lightPoints > 0 && movesLeft > 0 {
            print("You Win")
            showAlert(title: "You Win", message: "Play Again?")
            restartGame()
        } else if lightPoints <= 0 {
            print("You Lost")
            showAlert(title: "You Lost", message: "Play Again?")
            restartGame()
        } else if movesLeft <= 0 {
            print("You Lost")
            showAlert(title: "You Lost", message: "Play Again?")
            restartGame()
        }
    }
    
    func restartGame() {
        movesLeft = 10
        target = Int(arc4random_uniform(50) + 100)
        lightPoints = 15
        startingHand()
    }
    
    struct TouchInfo {
        var location: CGPoint
        var time: TimeInterval
    }
}
