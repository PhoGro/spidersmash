//
//  GameScene.swift
//  PEMDAS
//
//  Created by John Davenport on 8/16/17.
//  Copyright © 2017 John Davenport. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate, Alerts {
    
    
//MARK: SPIDER PROPERTIES
    
    //Initialize spawn positions for spiders
    let dzPosOne = CGPoint(x: -240, y: 180)
    let dzPosTwo = CGPoint(x: -240, y: 320)
    let dzPosThree = CGPoint(x: 0, y: 400)
    let dzPosFour = CGPoint(x: 240, y: 195)
    let dzPosFive = CGPoint(x: 240, y: 120)
    
    var spawnPositions = [CGPoint]() //contains an arrary of dzPOS above
    
    var spawnSpider: SKSpriteNode? //temp SKSpriteNode for spawning spiders
    var spawnAmount = 1 //tracks how many spiders to spawn at a time
    var spiders: [SKSpriteNode] = [] //an arrary of all spawned spiders
    var spiderCount = 0 //tracks how many spiders are on the game board
    var isAttacking = false //determines if a spider is currently attacking
    
    //Target for spiders to attack... may become the player's character in future version
    var spiderTarget = SKSpriteNode(imageNamed: "spiderTarget")
    var spiderTargetHealthCounter = 0
    var targetHealthLabel: SKLabelNode?
    var spiderTargetHealth: Double = 100 {
        didSet {
            targetHealthLabel?.text = "\(spiderTargetHealth)"
        }
    }
    
    
//MARK: PLAYER PROPERTIES
    
    //Allows player to select color of spider to attack
    var cardOne: SKSpriteNode?
    var cardTwo: SKSpriteNode?
    var cardThree: SKSpriteNode?
    var cardFour: SKSpriteNode?
    var cardFive: SKSpriteNode?
    
    //initialize positions for player's HUD positions
    let posOne = CGPoint(x: -160, y: -225)
    let posTwo = CGPoint(x: -80, y: -225)
    let posThree = CGPoint(x: 0, y: -225)
    let posFour = CGPoint(x: 80, y: -225)
    let posFive = CGPoint(x: 160, y: -225)
    
    var playerHand = [CGPoint]() //used to contain the positions (ABOVE) of the player's hand
    var playerCard: SKSpriteNode? //designates a player interactable sprite
    var deck = [SKSpriteNode]() //contains the cards that make up a player's deck of cards
    var chosenCard = SKSpriteNode() //temp designation for a card being that's been played and needs to e redrawn
    var newCardPosition: Int? //used for positing cards in and out of player's hand
    var selectedNode: SKSpriteNode? //generic variable to hold a sprite node which has been touched by a player
    var cardPosition: Int? //generic variable to denote the position of a card being interacted with by a player
    
//MARK: GAME PROPERITES

    let startButton = SKSpriteNode(imageNamed: "startButton") //allows player to start game
    var shuffleButton = SKSpriteNode(imageNamed: "shuffleButton") //allows player to shuffle colors available
    
    var highScoreLabel = SKLabelNode() //game's current highscore
    var highScore = UserDefaults().integer(forKey: "HIGHSCORE") //how we save highscore
    
    var startGame = false //determines if game is started
    
    var waveLevel = 1 //tracks current wave level, increases difficult as waves are completed
    var match = false //tracks whether or not a match has been made (set to false when touches begin, true on match collision)
    var spotTaken: Int? //tracks if a player's card already exists in the current location disallowing spawn
    
    var pointsLabel: SKLabelNode? //player's score
    var points: Int = 0 {
        didSet {
            pointsLabel?.text = "Score: \(points)"
        }
    }
    
//MARK: OVERRIDES
    
    override func didMove(to view: SKView) {
        
        // Setup physics world's contact delegate
        physicsWorld.contactDelegate = self
        
        //Initialize Starting board state
        startingHand()
        setupGame()
        
    }
    
    override func didSimulatePhysics() {
        
        // can i do more here?
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
        match = false //ensures that match is reset to false until a match is found
        
        //TODO: think about how to rewrite the touches code so that it is broken up into simplified methods.
        
        if startGame == false {
            
            //Start the game! (seperate into a startGame() function?
            
            if ((node as? SKSpriteNode)) == startButton {
                startGame = true
                startButton.removeFromParent()
                highScoreLabel.removeFromParent()
            }
            
        } else {
            
            //Player shuffles colors
            if ((node as? SKSpriteNode) != nil && node.name?.contains("shuffleButton") == true) {
                shuffleButtonPressed()
            } else if ((node as? SKSpriteNode) != nil) && (node.name?.contains("Spider") == false) {
                
                //player has selected a color
                
                selectedNode = node as? SKSpriteNode //sets node to selected node
                selectedNode?.zPosition = 100 //sets zPosition so selected node will be top layer
                
                //Sets the position for where the color was selected allowing it to return to that position if dropped by player or if an incorrect match has occurred.
                
                if (selectedNode?.contains(posOne))! {
                        cardPosition = 1
                } else if (selectedNode?.contains(posTwo))! {
                        cardPosition = 2
                } else if (selectedNode?.contains(posThree))! {
                        cardPosition = 3
                } else if (selectedNode?.contains(posFour))! {
                        cardPosition = 4
                } else if (selectedNode?.contains(posFive))! {
                        cardPosition = 5
                } else { print("Not a player card: \(String(describing: selectedNode))") }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //track the touch as it is moved across the screen. If the selected node is not nil
        //we set the node's position to the location of the touch.
        
        let touch = touches.first!
        let location = touch.location(in: self)
        
        //tracks movement of a player controlled colored card.
        if (selectedNode != nil) {
            selectedNode?.position = location
        }

    
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        var returnPos: CGPoint?
        
        //returns the selected card to the position where it was picked up from.
        
        if cardPosition == 1 {
            returnPos = posOne
        } else if cardPosition == 2 {
            returnPos = posTwo
        } else if cardPosition == 3 {
            returnPos = posThree
        } else if cardPosition == 4 {
            returnPos = posFour
        } else if cardPosition == 5 {
            returnPos = posFive
        }
        
        selectedNode?.position = returnPos!
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //If game has started, track and update, spider wave and update spiders.
        //Will probably need to update player here too as we build more complixity into the player's interactions
        if startGame == true {
            spiderWaveGenerator()
            updateSpider()
        }
        
        
    }
    
//MARK: GAME METHODS
    
    //MARK: PLAYER METHODS
    
    func setupGame() {
        
        //add start button
        startButton.position = CGPoint(x: 0.5, y: 5)
        startButton.zPosition = 100
        addChild(startButton)
        
        //set highscorelabe
        highScoreLabel = SKLabelNode()
        highScoreLabel.text = "High Score = \(UserDefaults().integer(forKey: "HIGHSCORE"))"
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.fontName = "AvenirNext-Bold"
        highScoreLabel.fontSize = 30
        highScoreLabel.zPosition = 5
        highScoreLabel.position = CGPoint(x: 0, y: 200)
        addChild(highScoreLabel)
        
        //add spider target
        spiderTarget.position = CGPoint(x: 0.5, y: -70)
        spiderTarget.name = "spiderTarget"
        spiderTarget.zPosition = 1
        spiderTarget.physicsBody = SKPhysicsBody(rectangleOf: spiderTarget.size)
        spiderTarget.physicsBody?.contactTestBitMask = 1
        spiderTarget.physicsBody?.collisionBitMask = 1
        spiderTarget.physicsBody?.isDynamic = false
        spiderTarget.physicsBody?.affectedByGravity = false
        spiderTarget.physicsBody?.categoryBitMask = 5
        addChild(spiderTarget)
        
        //add spider target health total
        targetHealthLabel = SKLabelNode()
        targetHealthLabel?.fontColor = SKColor.white
        targetHealthLabel?.fontSize = 10
        targetHealthLabel?.fontName = "AvenirNext-Bold"
        targetHealthLabel?.text = "\(spiderTargetHealth)"
        targetHealthLabel?.position = CGPoint(x: 0.5, y: -70)
        targetHealthLabel?.zPosition = 5
        addChild(targetHealthLabel!)
        
        //add shuffle hand button
        shuffleButton.name = "shuffleButton"
        shuffleButton.position = CGPoint(x: 0, y: -310)
        shuffleButton.zPosition = 1
        shuffleButton.physicsBody?.isDynamic = false
        addChild(shuffleButton)
        
        //Initialize ScoreLabel
        pointsLabel = SKLabelNode()
        pointsLabel?.fontColor = SKColor.white
        pointsLabel?.fontSize = 10
        pointsLabel?.fontName = "AvenirNext-Bold"
        pointsLabel?.text = "Score: \(points)"
        pointsLabel?.position = CGPoint(x: -130, y: 350)
        addChild(pointsLabel!)
        
        
        
        //Set the background
        let background = SKSpriteNode(imageNamed: "background")
        background.size = frame.size
        background.zPosition = -1
        background.position = CGPoint(x: 0.5, y: 0.5)
        addChild(background)
        
    }
    
    func createCard() -> SKSpriteNode {
        
        //create the five cards for a player's hand.
        cardOne = Card(cardType: .orange)
        cardTwo = Card(cardType: .purple)
        cardThree = Card(cardType: .yellow)
        cardFour = Card(cardType: .green)
        cardFive = Card(cardType: .blue)
        
        //Initialize the properties of each card
        cardOne?.name = "playerCard"
        cardOne?.texture = SKTexture(imageNamed: "Orange")
        
        cardTwo?.name = "playerCard"
        cardTwo?.texture = SKTexture(imageNamed: "Purple")
        
        cardThree?.name = "playerCard"
        cardThree?.texture = SKTexture(imageNamed: "Yellow")
        
        cardFour?.name = "playerCard"
        cardFour?.texture = SKTexture(imageNamed: "Green")
        
        cardFive?.name = "playerCard"
        cardFive?.texture = SKTexture(imageNamed: "Blue")
        
        //Creates an arrary of cards
        deck = [cardOne!, cardTwo!, cardThree!, cardFour!, cardFive!]
        
        //picks a random card from the arrary
        let randomCardNumber = Int(arc4random_uniform(UInt32(deck.count)))
        
        //renturs the random card to be used where this function is called.
        //called in intiial hand setup and when a new card is created to replace a played card
        return deck[randomCardNumber]
        
    }
    
    func startingHand() {
        
        //Clear Board State
        removeAllChildren()
        
        //an arrary for the player's card positions
        playerHand = [posOne, posTwo, posThree, posFour, posFive]
        
        
        //Creates a new card for each position in the payer's hand
        for item in playerHand {
            playerCard = createCard()
            playerCard?.position = item
            playerCard?.physicsBody = SKPhysicsBody(rectangleOf: (playerCard?.size)!)
            playerCard?.physicsBody?.contactTestBitMask = 1
            playerCard?.physicsBody?.collisionBitMask = 0
            playerCard?.physicsBody?.isDynamic = false
            playerCard?.physicsBody?.affectedByGravity = false
            playerCard?.physicsBody?.categoryBitMask = 1
            addChild(playerCard!)
        }
    }
    
    func shuffleButtonPressed() {
        
        enumerateChildNodes(withName: "playerCard", using: {
            node, stop in
            
            node.removeFromParent()
            
        })
        
        //an arrary for the player's card positions
        playerHand = [posOne, posTwo, posThree, posFour, posFive]
        
        
        //Creates a new card for each position in the payer's hand
        for item in playerHand {
            playerCard = createCard()
            playerCard?.position = item
            playerCard?.physicsBody = SKPhysicsBody(rectangleOf: (playerCard?.size)!)
            playerCard?.physicsBody?.contactTestBitMask = 1
            playerCard?.physicsBody?.collisionBitMask = 0
            playerCard?.physicsBody?.isDynamic = false
            playerCard?.physicsBody?.affectedByGravity = false
            playerCard?.physicsBody?.categoryBitMask = 1
            addChild(playerCard!)
        }
        
    }
    
    //MARK: SPIDER METHODS
    
    func createSpider() -> SKSpriteNode {
        
        //creates spiders
        let yellowSpider = Spider(spiderType: .yellowSpider)
        let blueSpider = Spider(spiderType: .blueSpider)
        let orangeSpider = Spider(spiderType: .orangeSpider)
        let greenSpider = Spider(spiderType: .greenSpider)
        let purpleSpider = Spider(spiderType: .purpleSpider)
        
        //Initialize the properties of each card
        yellowSpider.name = "YellowSpider"
        blueSpider.name = "BlueSpider"
        orangeSpider.name = "OrangeSpider"
        greenSpider.name = "GreenSpider"
        purpleSpider.name = "PurpleSpider"
        
        //Creates an arrary of cards
        let spiders = [yellowSpider, blueSpider, orangeSpider, greenSpider, purpleSpider]
        
        //picks a spider from the arrary
        let randomCardNumber = Int(arc4random_uniform(UInt32(spiders.count)))
        
        //returns a spider
        return spiders[randomCardNumber]
        
    }
    
    func spawnSpiders() {
        // this function spawns spiders
        
            spawnSpider = createSpider()
            spawnSpider?.position = spiderSpawnPosition()
            spawnSpider?.zPosition = 2
            spawnSpider?.physicsBody = SKPhysicsBody(rectangleOf: (spawnSpider?.size)!)
            spawnSpider?.physicsBody?.contactTestBitMask = 1
            spawnSpider?.physicsBody?.collisionBitMask = 1
            spawnSpider?.physicsBody?.restitution = 1
            spawnSpider?.physicsBody?.isDynamic = true
            spawnSpider?.physicsBody?.affectedByGravity = false
            spawnSpider?.physicsBody?.categoryBitMask = 3
            addChild(spawnSpider!)
            spiders.append(spawnSpider!)
            spiderCount += 1
    }
    
    func spiderSpawnPosition() -> CGPoint {
        
        spawnPositions = [dzPosOne,dzPosTwo,dzPosThree, dzPosFour, dzPosFive]
        let randomSpawnPos = Int(arc4random_uniform(UInt32(spawnPositions.count)))
        
        return spawnPositions[randomSpawnPos]
        
    }
    
    func spiderWaveGenerator() {
        
        while spawnAmount < (waveLevel * 2) {
            let wait = SKAction.wait(forDuration: 2)
            let spawn = SKAction.run {
                self.spawnSpiders()
            }
            let sequence = SKAction.sequence([wait,spawn])
            print("\(spawnAmount)")
            spawnAmount += 1
            
            run(sequence)
        }
    }
    
    func updateSpider() {
        
        spidarAttack()
        
        if self.childNode(withName: "BlueSpider") != nil || self.childNode(withName: "GreenSpider") != nil || self.childNode(withName: "YellowSpider") != nil || self.childNode(withName: "OrangeSpider") != nil || self.childNode(withName: "PurpleSpider") != nil {
         
            for spider in spiders {
            
            //Spider Speed
            let spiderSpeed = CGFloat(1.5)
            
            //Aim Spider
            let dx = spiderTarget.position.x - (spider.position.x)
            let dy = spiderTarget.position.y - (spider.position.y)
            let angle = atan2(dy, dx)
            
            spider.zRotation = angle
            
            //Seek
            let vx = cos(angle) * spiderSpeed
            let vy = sin(angle) * spiderSpeed
            
            spider.position.x += vx
            spider.position.y += vy
                
            }
        }
    }
    
    func spidarAttack() {
  
        if isAttacking == true {
            
            spiderTargetHealthCounter += 1
            
            if spiderTargetHealthCounter % 10 == 0 {
                spiderTargetHealth -= 1
            }
            
            if spiderTargetHealth < 1 {
                gameOver()
            }
        }
    }
    
    //MARK: GAMEPLAY METHODS
    
    func cardPlayed(playedCard: SKSpriteNode) {
        
        if cardPosition == 1 {
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
   
    func reDraw(cardPosition: Int) {
        
        chosenCard = createCard()
        
        //Determine which hand position needs to be replaced
        //Idea for animating cards. Spawn off screen and SKAction moveTo required POS
        if cardPosition == 1 {
            chosenCard.position = posOne
            newCardPosition = 1
            if positionIsEmpty(point: posOne) == 2 {
                addChild(chosenCard)
            } else {
                print("Spot was taken")
            }
        } else if cardPosition == 2 {
            chosenCard.position = posTwo
            newCardPosition = 2
            if positionIsEmpty(point: posTwo) == 2 {
                addChild(chosenCard)
            } else {
                print("Spot was taken")
            }
        } else if cardPosition == 3 {
            chosenCard.position = posThree
            newCardPosition = 3
            if positionIsEmpty(point: posThree) == 2 {
                addChild(chosenCard)
            } else {
                print("Spot was taken")
            }
        } else if cardPosition == 4 {
            chosenCard.position = posFour
            newCardPosition = 4
            if positionIsEmpty(point: posFour) == 2 {
                addChild(chosenCard)
            } else {
                print("Spot was taken")
            }
        } else if cardPosition == 5 {
            chosenCard.position = posFive
            newCardPosition = 5
            if positionIsEmpty(point: posFive) == 2 {
                addChild(chosenCard)
            } else {
                print("Spot was taken")
            }
        }
    }
    
    func bloodSplatter(pos: CGPoint) {
        
        let bloodSplat = SKSpriteNode(imageNamed: "bloodSplat")
        bloodSplat.position = pos
        bloodSplat.size = CGSize(width: 45, height: 45)
        bloodSplat.zPosition = 1
        addChild(bloodSplat)
        
    }
    
    func positionIsEmpty(point: CGPoint) -> Int {
    
        self.enumerateChildNodes(withName: "playerCard", using: {
            node, stop in
            
            let dot = node as! SKSpriteNode
            if (dot.frame.contains(point)) {
                print("spot taken")
                
                self.spotTaken = 1
            } else {
                self.spotTaken = 2
            }
        })
        
        return spotTaken!
    
    }
    
    func gameOver() {
        
        if points > UserDefaults().integer(forKey: "HIGHSCORE") {
            saveHighScore()
        }
        
        let gameOver = GameOverScene(size: (scene?.size)!)
        gameOver.scaleMode = .aspectFill
        
        gameOver.userData = NSMutableDictionary()
        gameOver.userData?.setObject(points, forKey: "score" as NSCopying)
        gameOver.userData?.setObject(highScore, forKey: "HS" as NSCopying)
        
        self.view?.presentScene(gameOver)
        
    }
    
    func restartGame() {
        
        spiderTargetHealthCounter = 0
        points = 0
        spiderCount = 0
        waveLevel = 1
        spawnAmount = 1
        removeAllActions()
        startGame = false
        startingHand()
        setupGame()
        
    }
    
    func saveHighScore() {
        UserDefaults.standard.set(points, forKey: "HIGHSCORE")
    }
    
    struct TouchInfo {
        var location: CGPoint
        var time: TimeInterval
    }
    
//MARK: GAME PHYSICS
    
    public func didBegin(_ contact: SKPhysicsContact) {
        // 1. Create local variables for two physics bodies
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        // 2. Assign the two physics bodies so that the one with the
        // lower category is always stored in firstBody
        
        /* category bit masks
         
         spiders - 3
         cards - 1
         spider target - 2
 
         */
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.node?.name?.contains("Spider"))! && (secondBody.node?.name?.contains("Target"))! {
            
            print("spider attacks spider target")
            spiderTargetHealth -= 2
            isAttacking = true
            
            if spiderTargetHealth < 1 {
                gameOver()
            }
            
        } else if firstBody.categoryBitMask == playerCard!.physicsBody?.categoryBitMask &&
            secondBody.categoryBitMask == spawnSpider?.physicsBody?.categoryBitMask {
           
            var cardName = "default"
            let cardNameComps = selectedNode?.texture?.description.components(separatedBy: "'")
            if cardNameComps?.count == 3 {
                cardName = cardNameComps![1]
            } else if cardNameComps?.count == 1 {
                    cardName = ""
                }
            let spiderName = secondBody.node?.name
            
            if (spiderName?.contains("\(cardName)"))! {
                
                firstBody.node?.removeFromParent()
                secondBody.node?.removeAllActions()
                secondBody.node?.removeFromParent()
                bloodSplatter(pos: (secondBody.node?.position)!)
                points += 10
                spiderCount -= 1
                isAttacking = false
                if spiderCount == 0 {
                    waveLevel += 1
                    spawnAmount = 1
                    print("Wave \(waveLevel) Income!")
                }
                pointsLabel?.text = "Score: \(points)"
                match = true
                print("Match")
                reDraw(cardPosition: cardPosition!)
                
            } else if cardName != secondBody.node?.name {
                print("PCName: \(cardName)")
                print("SpiderName: \(String(describing: secondBody.node?.name))")
                print("not a match")
            }
        }
    }
}
