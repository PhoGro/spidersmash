//
//  GameScene.swift
//  PEMDAS
//
//  Created by John Davenport on 8/16/17.
//  Copyright © 2017 John Davenport. All rights reserved.
//

import SpriteKit
import GameplayKit

class LevelOne: SKScene, SKPhysicsContactDelegate, Alerts, SceneManager {
    
    
//MARK: SPIDER PROPERTIES
    var spider: SKSpriteNode?
    var spawnPositions = [CGPoint]() //contains an arrary of dzPOS above
    var spawnSpider: Spider? //temp SKSpriteNode for spawning spiders
    var spawnAmount = 1 //tracks how many spiders to spawn at a time
    var spiders: [SKSpriteNode] = [] //an arrary of all spawned spiders
    var spiderCount = 0 //tracks how many spiders are on the game board
    var isAttacking = false //determines if a spider is currently attacking
    var playerColor = "default"
    var spiderHealth = 2
    
    var finalScore = 0
    
    /*spider movement*/
    let spiderRight = SKAction.moveBy(x: 35, y: 0, duration: 0.6)
    let spiderLeft = SKAction.moveBy(x: -35, y: 0, duration: 0.6)
    let spiderUp = SKAction.moveBy(x: 0, y: 35, duration: 0.6)
    let spiderDown = SKAction.moveBy(x: 0, y: -35, duration: 0.6)
 
    
//MARK: PLAYER PROPERTIES
    
    var player: SKSpriteNode!
    
    //player movement
    let playerRight = SKAction.moveBy(x: 50, y: 0, duration: 0.6)
    let playerLeft = SKAction.moveBy(x: -50, y: 0, duration: 0.6)
    let playerUp = SKAction.moveBy(x: 0, y: 50, duration: 0.6)
    let playerDown = SKAction.moveBy(x: 0, y: -50, duration: 0.6)
    
    //Allows player to select color of spider to attack
    var hammerOne: SKSpriteNode?
    var hammerTwo: SKSpriteNode?
    var hammerThree: SKSpriteNode?
    var hammerFour: SKSpriteNode?
    var hammerFive: SKSpriteNode?
    var activeHammer = SKSpriteNode(imageNamed: "defaultHammerRight")
    var hammerDirection = "HammerRight"
    
    //initialize positions for player's HUD positions
    
    var posOne = CGPoint(x: -120, y: -250)
    var posTwo = CGPoint(x: -60, y: -250)
    var posThree = CGPoint(x: 0, y: -250)
    var posFour = CGPoint(x: 60, y: -250)
    var posFive = CGPoint(x: 120, y: -250)
    
    var playerHand = [CGPoint]() //used to contain the positions (ABOVE) of the player's hand
    var playerCard: SKSpriteNode? //designates a player interactable sprite
    var deck = [SKSpriteNode]() //contains the cards that make up a player's deck of cards
    var chosenCard = SKSpriteNode() //temp designation for a card being that's been played and needs to e redrawn
    var newCardPosition: Int? //used for positing cards in and out of player's hand
    var selectedNode: SKSpriteNode? //generic variable to hold a sprite node which has been touched by a player
    var cardPosition: Int? //generic variable to denote the position of a card being interacted with by a player
    
    //Player's Health Properties
    var playerHealthCounter = 0
    var playerMaxHealth: Double = 100
    public var playerHealth: Double = 100
    let healthBar = HealthBar(color: SKColor.red, size:CGSize(width: 300, height: 5))
    
    var PlayerDirection: String = "movingRight"
    var ActiveHammer: String = "defaultActiveHammer"
    
    var playerAttacked = false
    
//MARK: GAME PROPERITES
    
    var lvlExitOpen = false
    var lvlExit: SKSpriteNode!
    public var nxtLvl = "LevelTwo"
    
    var heart: SKSpriteNode!
    
    public var score = 0
    public var timeElapsed = 0
    
    let startButton = SKSpriteNode(imageNamed: "startButton") //allows player to start game
    var shuffleButton = SKSpriteNode(imageNamed: "shuffleButton") //allows player to shuffle colors available
    
    public var highScoreLabel = SKLabelNode() //game's current highscore
    var highScore = UserDefaults().integer(forKey: "HIGHSCORE") //how we save highscore
    
    var startGame = false //determines if game is started
    
    public var waveLevel = 1 //tracks current wave level, increases difficult as waves are completed
//    var match = false //tracks whether or not a match has been made (set to false when touches begin, true on match collision)
    var spotTaken: Int? //tracks if a player's card already exists in the current location disallowing spawn
    
    var pointsLabel: SKLabelNode? //player's score
    var points: Int = 0 {
        didSet {
            pointsLabel?.text = "Score: \(points)"
        }
    }
    
    var levelTimerLabel = SKLabelNode(fontNamed: "ArialMT")
    
    //Immediately after leveTimerValue variable is set, update label's text
    public var levelTimerValue: Int = 0 {
        didSet {
            levelTimerLabel.text = "Time: \(levelTimerValue)"
        }
    }
    
    
    
    let playerCamera = SKCameraNode()
    let playerLight = SKLightNode()
    let playerHUD = SKNode()
    var selectedColor = SKSpriteNode(imageNamed: "default")
    
    var spiderCountLabel = SKLabelNode() //game's current highscore
    
//MARK: OVERRIDES
    
    override func didMove(to view: SKView) {
        
        // Setup physics world's contact delegate
        physicsWorld.contactDelegate = self
        
        //Initialize Starting board state
        self.camera = playerCamera
        playerCamera.addChild(playerHUD)
        setupGame()
        startingHand()
        startGame = true
        
    }
    
    override func didSimulatePhysics() {
        
        // can i do more here?
        healthBar.progress = (CGFloat(playerHealth / playerMaxHealth))
        
        if spider?.position != nil {
        
            if player.position.distance(point: (spider?.position)!) > 1 {
                isAttacking = false
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
     //   match = false //ensures that match is reset to false until a match is found
        
        if startGame == false {
            
            //Start the game! (seperate into a startGame() function?
            
            if ((node as? SKSpriteNode)) == startButton {
                
                startButton.removeFromParent()
                highScoreLabel.removeFromParent()
            }
            
        } else {
            
            //Player shuffles colors
            if ((node as? SKSpriteNode) != nil && node.name?.contains("shuffleButton") == true) {
                shuffleButtonPressed()
            } else if ((node as? SKSpriteNode) != nil) && (node.name?.contains("playerCard") == true) {
                
                //player has selected a color
                
                selectedNode = node as? SKSpriteNode //sets node to selected node
                selectedNode?.zPosition = 100 //sets zPosition so selected node will be top layer
                
                var cardName = "default"
                let cardNameComps = selectedNode?.texture?.description.components(separatedBy: "'")
                if cardNameComps?.count == 3 {
                    cardName = cardNameComps![1]
                } else if cardNameComps?.count == 1 {
                    cardName = ""
                }
              //  selectedColor.texture = SKTexture(imageNamed: "\(cardName)")
                playerColor = cardName
                
               // activeHammer.texture = SKTexture(imageNamed: "\(playerColor)"+"\(hammerDirection)")
                
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //track the touch as it is moved across the screen. If the selected node is not nil
        //we set the node's position to the location of the touch.
    
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //If game has started, track and update, spider wave and update spiders.
        //Will probably need to update player here too as we build more complixity into the player's interactions
        if startGame == true {
            spiderWaveGenerator()
            playerLight.position = player.position
            if playerAttacked == false {
                playerCamera.position = player.position
            }
            
            switch PlayerDirection {
            case "movingRight" :
                hammerDirection = "HammerRight"
                activeHammer.texture = SKTexture(imageNamed: "\(playerColor)"+"\(hammerDirection)")
                activeHammer.position = CGPoint(x: (player.position.x + 15), y: (player.position.y + 10))
            case "movingLeft" :
                hammerDirection = "HammerLeft"
                activeHammer.texture = SKTexture(imageNamed: "\(playerColor)"+"\(hammerDirection)")
                activeHammer.position = CGPoint(x: (player.position.x - 15), y: (player.position.y + 10))
            case "movingDown" :
                hammerDirection = "HammerDown"
                activeHammer.texture = SKTexture(imageNamed: "\(playerColor)"+"\(hammerDirection)")
                activeHammer.position = CGPoint(x: (player.position.x), y: (player.position.y - 20))
            case "movingUp" :
                hammerDirection = "HammerUp"
                activeHammer.texture = SKTexture(imageNamed: "\(playerColor)"+"\(hammerDirection)")
                activeHammer.position = CGPoint(x: (player.position.x), y: (player.position.y + 20))
            default : break
            }
            
        }
        
        if playerHealth < 1 {
            gameOver()
        }
        
    }
    
    func activeHammer(direction: String, color: String) {
        
        
        // directions - up, down, left, right
        // colors - blue, green, yellow, orange, purple
        
        
        
    }
    
//MARK: GAME METHODS
    
    //MARK: PLAYER METHODS
    
    func setupGame() {
        
        print("Current Wave: \(waveLevel)")
        
        
        //add player
        player = childNode(withName: "player") as! SKSpriteNode
        player.name = "hero"
        player.zPosition = 3
        player.physicsBody = SKPhysicsBody(rectangleOf: (player.size))
        player.physicsBody?.collisionBitMask = 1
        player.physicsBody?.contactTestBitMask = 1
        player.physicsBody?.categoryBitMask = 4
        player.physicsBody?.isDynamic = true
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.affectedByGravity = false
        player.lightingBitMask = 5
        player.shadowedBitMask = 0
        player.shadowCastBitMask = 0
        
        //add camera
        playerCamera.position = (player.position)
        playerCamera.xScale = 1.0
        playerCamera.yScale = 1.0
        addChild(playerCamera)
        
        //addHUD
        playerHUD.zPosition = 1000
        
        //add light
        playerLight.position = (player.position)
        playerLight.falloff = 2.0
        playerLight.lightColor = SKColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        playerLight.isEnabled = true
        playerLight.categoryBitMask = 5
        playerLight.zPosition = 100
        addChild(playerLight)
        
        //players health bar
        healthBar.position = CGPoint(x: 0, y: -(frame.height/4))
        healthBar.zPosition = 2
        playerHUD.addChild(healthBar)
        
        //add shuffle button
        shuffleButton.name = "shuffleButton"
        shuffleButton.position = CGPoint(x: 0, y: -310)
        shuffleButton.physicsBody?.isDynamic = false
        shuffleButton.zPosition = 2
        playerHUD.addChild(shuffleButton)
        
        //add default active hammer
        activeHammer.position = CGPoint(x: (player.position.x + 15), y: (player.position.y + 10))
        activeHammer.size = CGSize(width: player.size.width, height: player.size.height)
        activeHammer.zPosition = 2
        addChild(activeHammer)
        
        //add ScoreLabel
        pointsLabel = SKLabelNode()
        pointsLabel?.fontColor = SKColor.white
        pointsLabel?.fontSize = 10
        pointsLabel?.fontName = "AvenirNext-Bold"
        pointsLabel?.text = "Score: \(points)"
        pointsLabel?.position = CGPoint(x: -130, y: -310)
        pointsLabel?.zPosition = 2
        playerHUD.addChild(pointsLabel!)
        
        //spiderCountLabel
        spiderCountLabel = SKLabelNode()
        spiderCountLabel.fontColor = SKColor.white
        spiderCountLabel.fontSize = 10
        spiderCountLabel.fontName = "AvenirNext-Bold"
        spiderCountLabel.text = "Spiders Left: \(spiderCount)"
        spiderCountLabel.position = CGPoint(x: 130, y: -310)
        spiderCountLabel.zPosition = 2
        playerHUD.addChild(spiderCountLabel)
        
        //add selectedColor
//        selectedColor.position = CGPoint(x: 140, y: -169)
//        selectedColor.size = CGSize(width: 40, height: 62)
//        selectedColor.zPosition = -1000
//        playerHUD.addChild(selectedColor)
        
        //Set the background
        let background = SKSpriteNode(imageNamed: "background")
        background.zPosition = -1
        background.size = frame.size
        background.position = CGPoint(x: 0.5, y: 0.5)
        background.lightingBitMask = 5
        
        background.normalTexture = background.texture?.generatingNormalMap(withSmoothness: 0.2, contrast: 0.2)
        
        addChild(background)
        
        //Set the background
        let playerHUDbackground = SKSpriteNode(imageNamed: "playerHUD2")
        playerHUDbackground.size = CGSize(width: 340, height: 150)
        playerHUDbackground.position = CGPoint(x: 0.0, y: -250)
        playerHUDbackground.zPosition = 0
        playerHUD.addChild(playerHUDbackground)
        
        //add level exit
        lvlExit = childNode(withName: "lvlExit") as! SKSpriteNode
        lvlExit.name = "lvlExit"
        lvlExit.zPosition = 3
        lvlExit.physicsBody = SKPhysicsBody(rectangleOf: (lvlExit.size))
        lvlExit.physicsBody?.collisionBitMask = 1
        lvlExit.physicsBody?.contactTestBitMask = 1
        lvlExit.physicsBody?.categoryBitMask = 3
        lvlExit.physicsBody?.isDynamic = false
        lvlExit.physicsBody?.allowsRotation = false
        lvlExit.physicsBody?.affectedByGravity = false
        lvlExit.lightingBitMask = 5
        lvlExit.shadowedBitMask = 5
        lvlExit.shadowCastBitMask = 5
        
        
        levelTimerLabel.fontColor = SKColor.green
        levelTimerLabel.fontSize = 12
        levelTimerLabel.zPosition = 10
        levelTimerLabel.position = CGPoint(x: 0, y: -210)
        levelTimerLabel.text = "Time left: \(levelTimerValue)"
        playerHUD.addChild(levelTimerLabel)
        
        let wait = SKAction.wait(forDuration: 0.5) //change countdown speed here
        let block = SKAction.run({
            [unowned self] in
            
            self.levelTimerValue += 1
            
        })
        let sequence = SKAction.sequence([wait,block])
        
        run(SKAction.repeatForever(sequence), withKey: "countdown")
        
        //define swipe gestures for player movement
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view?.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view?.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view?.addGestureRecognizer(swipeUp)
        
    }
    
    func createCard() -> SKSpriteNode {
        
        //create the five cards for a player's hand.
        hammerOne = Hammer(hammerType: .purple)
        hammerTwo = Hammer(hammerType: .orange)
        hammerThree = Hammer(hammerType: .yellow)
        hammerFour = Hammer(hammerType: .green)
        hammerFive = Hammer(hammerType: .blue)
        
        //Initialize the properties of each card
        hammerOne?.name = "playerCard"
        hammerOne?.texture = SKTexture(imageNamed: "Orange")
        
        hammerTwo?.name = "playerCard"
        hammerTwo?.texture = SKTexture(imageNamed: "Purple")
        
        hammerThree?.name = "playerCard"
        hammerThree?.texture = SKTexture(imageNamed: "Yellow")
        
        hammerFour?.name = "playerCard"
        hammerFour?.texture = SKTexture(imageNamed: "Green")
        
        hammerFive?.name = "playerCard"
        hammerFive?.texture = SKTexture(imageNamed: "Blue")
        
        //Creates an arrary of cards
        deck = [hammerOne!, hammerTwo!, hammerThree!, hammerFour!, hammerFive!]
        
        //picks a random card from the arrary
        let randomCardNumber = Int(arc4random_uniform(UInt32(deck.count)))
        
        //renturs the random card to be used where this function is called.
        //called in intiial hand setup and when a new card is created to replace a played card
        return deck[randomCardNumber]
        
    }
    
    func startingHand() {
        
        //an arrary for the player's card positions
        playerHand = [posOne, posTwo, posThree, posFour, posFive]
        
        
        //Creates a new card for each position in the payer's hand
        for item in playerHand {
            playerCard = createCard()
            playerCard?.position = item
            playerCard?.size = player.size
            playerCard?.zPosition = 2
            playerHUD.addChild(playerCard!)
        }
    }
    
    func shuffleButtonPressed() {
        
        playerHUD.enumerateChildNodes(withName: "playerCard", using: {
            node, stop in
            
            node.removeFromParent()
            
        })
        
        //an arrary for the player's card positions
       // playerHand = [posOne, posTwo, posThree, posFour, posFive]
        
        
        //Creates a new card for each position in the payer's hand
        for item in playerHand {
            playerCard = createCard()
            playerCard?.position = item
            playerCard?.zPosition = 2
            playerCard?.size = player.size
            playerHUD.addChild(playerCard!)
        }
        
    }
    
    func gainLife() {

        if playerMaxHealth - playerHealth > 25 {
            playerHealth = playerHealth + 25
        } else {
            playerHealth = playerMaxHealth
        }
    }
    
    func updatePlayer(touchLocation: CGPoint) {
        

    }
    
    //switch out player's textures depending on swiped movement
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                player.run(playerRight)
                player.texture = SKTexture(imageNamed: "player-right")
                PlayerDirection = "movingRight"
                updateSpider()
            case UISwipeGestureRecognizerDirection.down:
                player.run(playerDown)
                player.texture = SKTexture(imageNamed: "player-down")
                PlayerDirection = "movingDown"
                updateSpider()
            case UISwipeGestureRecognizerDirection.left:
                player.run(playerLeft)
                player.texture = SKTexture(imageNamed: "player-left")
                PlayerDirection = "movingLeft"
                updateSpider()
            case UISwipeGestureRecognizerDirection.up:
                player.run(playerUp)
                player.texture = SKTexture(imageNamed: "player-up")
                PlayerDirection = "movingUp"
                updateSpider()
            default:
                break
            }
        }
    }
    
    //animation for player movement
    func swipedRight(sender:UISwipeGestureRecognizer){
        player.run(playerRight)
    }
    func swipedLeft(sender:UISwipeGestureRecognizer){
        player.run(playerLeft)
    }
    func swipedUp(sender:UISwipeGestureRecognizer){
        player.run(playerUp)
    }
    func swipedDown(sender:UISwipeGestureRecognizer){
        player.run(playerDown)
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
        
            spawnSpider = createSpider() as? Spider
            spawnSpider?.spiderMaxHealth = 2
            spawnSpider?.spiderHealth = 2
            spawnSpider?.position = spiderSpawnPosition()
            spawnSpider?.zPosition = 2
            spawnSpider?.physicsBody = SKPhysicsBody(rectangleOf: (spawnSpider?.size)!)
            spawnSpider?.physicsBody?.contactTestBitMask = 1
            spawnSpider?.physicsBody?.collisionBitMask = 1
            spawnSpider?.physicsBody?.categoryBitMask = 3
            spawnSpider?.physicsBody?.isDynamic = true
            spawnSpider?.physicsBody?.affectedByGravity = false
            spawnSpider?.lightingBitMask = 5
            spawnSpider?.shadowedBitMask = 5
            spawnSpider?.shadowedBitMask = 5
            addChild(spawnSpider!)
            spiders.append(spawnSpider!)
            spiderCount += 1
            spiderCountLabel.text = "Spiders Left: \(self.spiderCount)"
    }
    
    func spiderSpawnPosition() -> CGPoint {
        let height = frame.height / 2
        let width = frame.width / 2
        
        let randomHeight = CGFloat(arc4random()).truncatingRemainder(dividingBy: height)
        let randomWidth = CGFloat(arc4random()).truncatingRemainder(dividingBy: width)
        
        let spiderPOS = makePositiveorNegative(height: randomHeight, width: randomWidth)
        
        return spiderPOS
        
    }
    
    
    
    func makePositiveorNegative(height: CGFloat, width: CGFloat) -> CGPoint {
        
        var spiderHeight = height
        var spiderWidth = width
        let randomHeight = arc4random_uniform(2)
        let randomWidth = arc4random_uniform(2)
        
        if randomHeight == 0 {
            spiderHeight = height
        } else if randomHeight == 1 {
            spiderHeight = height * -1
        }
        
        if randomWidth == 0 {
            spiderWidth = width
        } else if randomWidth == 1 {
            spiderWidth = width * -1
        }
        
        let spiderPOS = CGPoint(x: spiderWidth, y: spiderHeight)
        
        return spiderPOS
        
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
    
        if self.childNode(withName: "BlueSpider") != nil || self.childNode(withName: "GreenSpider") != nil || self.childNode(withName: "YellowSpider") != nil || self.childNode(withName: "OrangeSpider") != nil || self.childNode(withName: "PurpleSpider") != nil {
            
            for spider in spiders {
                
                
                //Spider Speed
                let spiderSpeed = CGFloat(20.0)
                let dx = player.position.x - (spider.position.x)
                let dy = player.position.y - (spider.position.y)
                let angle = atan2(dy, dx)
                spider.zRotation = angle
                let vx = cos(angle) * spiderSpeed
                let vy = sin(angle) * spiderSpeed
                let spiderMove = SKAction.moveBy(x: vx, y: vy, duration: 0.6)
                
                if dx < 50 && dy < 50 {
                    spider.run(spiderMove)
                } else {
                    spider.run(randomSpiderMove())
                }
            }
        }
    }
    
    func randomSpiderMove() -> SKAction {
        
        //Creates an arrary of cards
        let randomSpiderMoves = [spiderUp, spiderDown, spiderLeft, spiderRight]
        
        //picks a random card from the arrary
        let randomSpiderMove = Int(arc4random_uniform(UInt32(randomSpiderMoves.count)))
        
        //renturs the random card to be used where this function is called.
        //called in intiial hand setup and when a new card is created to replace a played card
        return randomSpiderMoves[randomSpiderMove]
        
        
    }
    
    func playerDamage() -> Int {
        
        var randomDamage = Int(arc4random_uniform(3)+1)
        
        let blockChance = Int(arc4random_uniform(100)+1)
        
        if blockChance < 10 {
            randomDamage = 0
        }
        
        return randomDamage
        
    }
    
    func spiderDamage() -> Int {
        
        var randomDamage = Int(arc4random_uniform(10)+1)
        
        let blockChance = Int(arc4random_uniform(100)+1)
        
        if blockChance < 10 {
            randomDamage = 0
        }
        
        return randomDamage
        
    }
    
    //MARK: GAMEPLAY METHODS
    
    func bloodSplatter(pos: CGPoint) {
        
        let bloodSplat = SKSpriteNode(imageNamed: "bloodSplat")
        bloodSplat.position = pos
        bloodSplat.size = (spawnSpider?.size)!
        bloodSplat.zPosition = 1
        bloodSplat.lightingBitMask = 5
        addChild(bloodSplat)
        
    }
    
    func hammerAnimations(direction: String) {
        
        let direction = direction
        
        let hitAnimation = SKAction.rotate(byAngle: 90, duration: 0.1)
        let hitAnimationReturn = SKAction.rotate(byAngle: -90, duration: 0.1)
        let hitAnimationSequence = SKAction.sequence([hitAnimation, hitAnimationReturn])
        
        switch direction {
            case "movingRight" : activeHammer.run(hitAnimationSequence)
            case "movingLeft" : activeHammer.run(hitAnimationSequence)
            case "movingDown" : activeHammer.run(hitAnimationSequence)
            case "movingUp" : activeHammer.run(hitAnimationSequence)
            default : break
        }
        
    }
    
    
    func gameOver() {
        
        finalScore = (points * Int(playerHealth)) / (levelTimerValue / 10)
        startGame = false
        
        if finalScore > UserDefaults().integer(forKey: "HIGHSCORE") {
            saveHighScore()
        }
        
        let gameOver = GameOverScene(size: (self.scene?.size)!)
        //let gameOver = GameOverScene(fileNamed: "GameOverScene")
        gameOver.scaleMode = .aspectFill
        gameOver.userData = NSMutableDictionary()
        gameOver.userData?.setObject(finalScore, forKey: "score" as NSCopying)
        gameOver.userData?.setObject(highScore, forKey: "HS" as NSCopying)
        
        self.view?.presentScene(gameOver)
        
    }
    
    private func goTo(nextLevel: SceneIdentifier) {
        
        // pass key for next level which is passed from didMove to view of previous level
        print("loading scene for \(nxtLvl)")
//        loadScene(withIdentifier: SceneIdentifier(rawValue: nxtLvl)!)
        
        loadScene(withIdentifier: SceneIdentifier(rawValue: nxtLvl)!, currentScore: points, currentTime: levelTimerValue, currentPlayerHealth: playerHealth)
        
    }
    
    public func restartGame() {
        
        //Clear Board State
        removeAllChildren()
        
        playerHealth = playerMaxHealth
        points = 0
        spiderCount = 0
        waveLevel = 1
        spawnAmount = 1
        removeAllActions()
        startGame = false
        
    }
    
    func saveHighScore() {
        UserDefaults.standard.set(finalScore, forKey: "HIGHSCORE")
    }
    
    func damageAnimationCounter(position: CGPoint) -> SKLabelNode {
        
        let damageLabel = SKLabelNode()
        let position = CGPoint(x: position.x, y: position.y + 40)
        
        damageLabel.fontSize = 18
        damageLabel.fontColor = SKColor.white
        damageLabel.fontName = "Futura-CondensedExtraBold"
        damageLabel.position = position
        damageLabel.zPosition = 1500
        damageLabel.name = "damageLabel"
        
        return damageLabel
        
    }
    
    struct TouchInfo {
        var location: CGPoint
        var time: TimeInterval
    }
    
    func combatStarts(spider: SKSpriteNode, player: SKSpriteNode, color: String) {
        
        let player = player
        let spider = spider as? Spider
        let color = color
        
        let dx = (spider?.position.x)! - (player.position.x)
        let dy = (spider?.position.y)! - (player.position.y)
        let angle = atan2(dy, dx)
        let vx = cos(angle) * 1.5
        let vy = sin(angle) * 1.5
        let playerAttacks = SKAction.moveBy(x: vx, y: vy, duration: 0.2)
        let spiderAttacks = SKAction.moveBy(x: -vx, y: -vy, duration: 0.2)
        let wait = SKAction.wait(forDuration: 0.2)
        let hitAnimation = SKEmitterNode(fileNamed: "GreenScatter")
        
        //Player Attacks Spider
        if (spider?.name?.contains(color))! {
            print("player is attacking")
            playerAttacked = true
            let attackDamage = playerDamage()
            let damage = damageAnimationCounter(position: spider!.position)
            
            spider?.physicsBody?.collisionBitMask = 0
            player.zPosition = 10
            
            player.run(playerAttacks, completion: {
                self.hammerAnimations(direction: self.PlayerDirection)
                let hitAn = hitAnimation
                hitAn?.position = (spider?.position)!
                self.addChild((hitAn)!)
                hitAn?.run(wait, completion: {hitAn?.removeFromParent()})
                
                if attackDamage == 0 {
                    print("BLOCKED")
                    damage.text = "BLOCK"
                    damage.fontColor = SKColor.blue
                    self.addChild(damage)
                    damage.run(SKAction.moveBy(x: -5, y: 15, duration: 0.3), completion: {damage.run(SKAction.fadeOut(withDuration: 0.7), completion: { damage.removeFromParent()})})
                    
                    
                } else {
                    spider?.spiderHealth -= attackDamage
                    damage.text = "\(attackDamage)"
                    damage.fontColor = SKColor.white
                    self.addChild(damage)
                    damage.run(SKAction.moveBy(x: -5, y: 15, duration: 0.3), completion: {damage.run(SKAction.fadeOut(withDuration: 0.7), completion: { damage.removeFromParent()})})
                }
                
                //if spider dies
                if (spider?.spiderHealth)! < 1 {
                    spider?.removeFromParent()
                    player.removeAllActions()
                    self.bloodSplatter(pos: (spider?.position)!)
                    self.points += 10
                    self.spiderCount -= 1
                    self.spiderCountLabel.text = "Spiders Left: \(self.spiderCount)"
                    self.pointsLabel?.text = "Score: \(self.points)"
                    // advance to next wave
                    if self.spiderCount == 0 {
                        self.lvlExit.color = .green
                        self.lvlExitOpen = true
                    }
                    self.playerAttacked = false
                    //reset player's positining/physics body
                    player.zPosition = 3
                    spider?.physicsBody?.collisionBitMask = 1
                    //if spider is still alive
                } else if self.playerAttacked == true && spider!.spiderHealth > 0 {
                    print("sider can counter attack")
                    player.zPosition = 3
                    spider?.physicsBody?.collisionBitMask = 1
                    player.physicsBody?.collisionBitMask = 0
                    spider?.zPosition = 10
                    
                    spider?.run(spiderAttacks, completion: {
                        
                        let spiderAttackDamage = self.spiderDamage()
                        let damage = self.damageAnimationCounter(position: player.position)
                        
                        if spiderAttackDamage == 0 {
                            print("BLOCKED")
                            damage.text = "BLOCK"
                            damage.fontColor = SKColor.green
                            self.addChild(damage)
                            damage.run(SKAction.moveBy(x: 5, y: 15, duration: 0.3), completion: {damage.run(SKAction.fadeOut(withDuration: 0.7), completion: { damage.removeFromParent()})})
                            
                            
                        } else {
                            self.playerHealth -= Double(spiderAttackDamage)
                            damage.text = "\(spiderAttackDamage)"
                            damage.fontColor = SKColor.red
                            self.addChild(damage)
                            damage.run(SKAction.moveBy(x: 5, y: 15, duration: 0.3), completion: {damage.run(SKAction.fadeOut(withDuration: 0.7), completion: { damage.removeFromParent()})})
                        }
                        
                        
                        player.physicsBody?.collisionBitMask = 1
                        
                        
                    })
                    
                    spider?.zPosition = 2
                    self.playerAttacked = false
                    
                }
                
            })
            
        }
            
        
    
        //Spider Attacks Player
        if (spider?.name?.contains(color))! == false {
            print("spider is attacking")
            
            player.physicsBody?.collisionBitMask = 0
            spider?.zPosition = 10
            
            spider?.run(spiderAttacks, completion: {
                let spiderAttackDamage = self.spiderDamage()
                let damage = self.damageAnimationCounter(position: player.position)
                
                if spiderAttackDamage == 0 {
                    print("BLOCKED")
                    damage.text = "BLOCK"
                    damage.fontColor = SKColor.green
                    self.addChild(damage)
                    damage.run(SKAction.moveBy(x: 0, y: 10, duration: 0.3), completion: {damage.run(SKAction.fadeOut(withDuration: 0.7), completion: { damage.removeFromParent()})})
                    
                    
                } else {
                    self.playerHealth -= Double(spiderAttackDamage)
                    damage.text = "\(spiderAttackDamage)"
                    damage.fontColor = SKColor.red
                    self.addChild(damage)
                    damage.run(SKAction.moveBy(x: 0, y: 10, duration: 0.3), completion: {damage.run(SKAction.fadeOut(withDuration: 0.7), completion: { damage.removeFromParent()})})
                }
                
                
                player.physicsBody?.collisionBitMask = 1
            })
            
            spider?.zPosition = 2
        }
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
        
        if (firstBody.node?.name?.contains("Spider"))! && (secondBody.node?.name?.contains("hero"))! {
            
            //combat has started - how do we handle this interaction?
            
            //Spider is the firstbody and player is secondBody
            
            let spider = firstBody.node as! SKSpriteNode
            let player = secondBody.node as! SKSpriteNode
            var cardName = "default"
            cardName = playerColor
            print("CardName: \(cardName)")
            
            combatStarts(spider: spider, player: player, color: cardName)
            
        } else if (firstBody.node?.name?.contains("lvlExit"))! && (secondBody.node?.name?.contains("hero"))!  {
            if lvlExitOpen == false {
                print("Kill more spiders")
            } else if lvlExitOpen == true {
                print("Advance to next level")
                if nxtLvl != "GameOver" {
                    goTo(nextLevel: SceneIdentifier(rawValue: nxtLvl)!)
                } else if nxtLvl == "GameOver" {
                    gameOver()
                }

            }
        } else if (firstBody.node?.name?.contains("heart"))! && (secondBody.node?.name?.contains("hero"))!  {
            
                let heartAnimation = SKEmitterNode(fileNamed: "heart")
                heartAnimation?.position = (firstBody.node!.position)
                self.addChild((heartAnimation)!)
                heartAnimation?.run(SKAction.wait(forDuration: 0.3), completion: {heartAnimation?.removeFromParent()})
                gainLife()
                firstBody.node?.removeFromParent()
                
        }
    }
}

extension CGPoint {
    func distance(point: CGPoint) -> CGFloat {
        return abs(CGFloat(hypotf(Float(point.x - x), Float(point.y - y))))
    }
}


//    func playerAttack(spider: SKSpriteNode, player: SKSpriteNode, color: String ) {
//
//        var attackTurn = 0
//
//        if (spider.name?.contains(color))! {
//
//            let dx = spider.position.x - (player.position.x)
//            let dy = spider.position.y - (player.position.y)
//            let angle = atan2(dy, dx)
//            let vx = cos(angle) * 1.5
//            let vy = sin(angle) * 1.5
//            let playerAttacks = SKAction.moveBy(x: vx, y: vy, duration: 0.2)
//         //   let spiderAttacks = SKAction.moveBy(x: -vx, y: -vy, duration: 0.2)
//
//            //Player Attack!
//
//            if spawnSpiderHealth > 0 && attackTurn % 2 == 0 {
//
//                spider.physicsBody?.collisionBitMask = 0
//                player.zPosition = 10
//                playerAttacked = true
//
//                player.run(playerAttacks, completion: {
//                    self.spawnSpiderHealth -= 1
//                    attackTurn = 1
//
//                        //spider dies
//                        if self.spawnSpiderHealth <= 0 {
//                            spider.removeFromParent()
//                            player.removeAllActions()
//                            self.bloodSplatter(pos: (spider.position))
//                            self.points += 10
//                            self.spiderCount -= 1
//                            self.spiderCountLabel.text = "Spiders Left: \(self.spiderCount)"
//                            self.pointsLabel?.text = "Score: \(self.points)"
//                            // advance to next wave
//                            if self.spiderCount == 0 {
//                                self.lvlExit.color = .green
//                                self.lvlExitOpen = true
//                            }
//                            attackTurn = 0
//                        }
//
//                    //reset player's positining/physics body
//                    player.zPosition = 3
//                    spider.physicsBody?.collisionBitMask = 1
//                    self.playerAttacked = false
//
//                })
//
//                //spider counter attack
//                if attackTurn == 1 {
//
//                    if spawnSpiderHealth < 1 {
//                        print("Spider is dead")
//                    } else if spawnSpiderHealth > 0 {
//                        //spider is alive - counter attack!
//                        print("Counter Attack!")
//                        spiderAttack(spider: spider, player: player, color: color)
//                        attackTurn = 0
////                        player.physicsBody?.collisionBitMask = 0
////                        spider.zPosition = 10
////
////                        spider.run(spiderAttacks, completion: {
////                            self.playerHealth -= 10
////                            attackTurn = 0
////                            spider.zPosition = 2
////                            player.physicsBody?.collisionBitMask = 1
////                            spider.physicsBody?.collisionBitMask = 1
////                            self.playerAttacked = false
////
////                        })
//                    }
//                }
//            }
//        }
//    }
//
//
//    func spiderAttack(spider: SKSpriteNode, player: SKSpriteNode, color: String ) {
//        player.removeAllActions()
//        if (spider.name?.contains(color))! == false {
//
//            player.physicsBody?.collisionBitMask = 0
//            spider.zPosition = 10
//            let originalSpiderPosition = spider.position
//
//            let attackAnimation = SKAction.move(to: player.position, duration: 0.2)
//            let attackReturn = SKAction.move(to: originalSpiderPosition, duration: 0.2)
//            let attackSequence = SKAction.sequence([attackAnimation, attackReturn])
//            spider.run(attackSequence, completion: {
//                self.playerHealth -= 10
//                player.physicsBody?.collisionBitMask = 1
//            })
//        } else if (spider.name?.contains(color))! == true {
//
//            player.physicsBody?.collisionBitMask = 0
//            spider.zPosition = 10
//            let originalSpiderPosition = spider.position
//
//            let attackAnimation = SKAction.move(to: player.position, duration: 0.2)
//            let attackReturn = SKAction.move(to: originalSpiderPosition, duration: 0.2)
//            let attackSequence = SKAction.sequence([attackAnimation, attackReturn])
//            spider.run(attackSequence, completion: {
//                self.playerHealth -= 10
//                player.physicsBody?.collisionBitMask = 1
//            })
//        }
//
//        spider.zPosition = 2
//
//    }
