//
//  GameScene.swift
//  PEMDAS
//
//  Created by John Davenport on 8/16/17.
//  Copyright © 2017 John Davenport. All rights reserved.
//

import SpriteKit
import GameplayKit

class CoreGame: SKScene, SKPhysicsContactDelegate, Alerts, SceneManager {
    
    
//MARK: SPIDER PROPERTIES
    
    var spider: SKSpriteNode?
    var boss: SKSpriteNode?
    var spawnPositions = [CGPoint]() //contains an arrary of dzPOS above
    var spawnSpider: Spider? //temp SKSpriteNode for spawning spiders
    var spawnAmount = 1 //tracks how many spiders to spawn at a time
    var bossCount = 0
    var spiders: [Spider] = [] //an arrary of all spawned spiders
    var bosses: [Boss] = []
    let spiderAtlas = SKTextureAtlas(named: "Spiders")
    let bossAtlas = SKTextureAtlas(named: "Boss")
    var spiderDamageMultiplier: Double = 1.0
    var spiderHealthMultiplier: Double = 1.0
   // var spiderHealth = 4 //spider healthpoints
    var spiderMaxDamage = 8 //maximum damange a spider can do
    var spiderCrit = false //gives a spider a chance to earn a critical damage mutltipler
    var spiderIsDead = false //determines if a spider is dead

    //spider's random movement - non-combat movement
    let spiderRight = SKAction.moveBy(x: 15, y: 0, duration: 0.5)
    let spiderLeft = SKAction.moveBy(x: -15, y: 0, duration: 0.5)
    let spiderUp = SKAction.moveBy(x: 0, y: 15, duration: 0.5)
    let spiderDown = SKAction.moveBy(x: 0, y: -15, duration: 0.5)
    
    var SpiderDirection: String = "spiderRight"
    var spiderAttacking = false
    var spiderAttacked = false
    
    //spider range attack?
   // var spiderProjectile = SKSpriteNode(imageNamed: "green")
    var spiderProjectileMaxDmg = 5
    var spiderProjectileFired = false
    
//MARK: PLAYER PROPERTIES
    
    var player: Hero = Hero()
    var playerColor = "default" //color of selected ax - default (gray) is set at the start of a level
    var retreat = false // variable used to determine if player has retreated from combat
    
    let playerAtlas = SKTextureAtlas(named: "Player")
    
    let playerRunRightAtlas = SKTextureAtlas(named: "playerRunRight")
    var playerRunRightArray: [SKTexture] = []
    let playerRunLeftAtlas = SKTextureAtlas(named: "playerRunLeft")
    var playerRunLeftArray: [SKTexture] = []
    let playerAttackRightAtlas = SKTextureAtlas(named: "playerAttackRight")
    var playerAttackRightArray: [SKTexture] = []
    let playerAttackLeftAtlas = SKTextureAtlas(named: "playerAttackLeft")
    var playerAttackLeftArray: [SKTexture] = []
    
    var playerCanAttack = true
    var playerCoolDown = 0
    var playerCoolDownStarted = false
    
    
    //player movement
    var playerRight = SKAction()
    var playerLeft = SKAction()
    var playerUp = SKAction()
    var playerDown = SKAction()
    
    //Allows player to select color of spider to attack
    var hammerOne: SKSpriteNode?
    var hammerTwo: SKSpriteNode?
    var hammerThree: SKSpriteNode?
    var hammerFour: SKSpriteNode?
    var hammerFive: SKSpriteNode?
    var activeHammer = SKSpriteNode(imageNamed: "defaultHammerRight") //to determine which color is active
    var hammerDirection = "HammerRight" // to determine which texture to display based on player's direction
    var playerMaxDamage: Double = 10 // maximum damage a player can do
    var playerMinDamage: Double = 5 // minium damage a player can do
    var playerCrit = false // allows player a chance to earn a critical damage multipler
    var selectedNode: SKSpriteNode? //generic variable to hold a sprite node which has been touched by a player
    let hammerAtlas = SKTextureAtlas(named: "ActiveHammers")
    //Player's Health Properties
    var playerHealthCounter = 0
    var playerMaxHealth: Double = 500
    public var playerHealth: Double = 500
    let healthBar = HealthBar(color: SKColor.red, size:CGSize(width: 340, height: 5))
    
    var PlayerDirection: String = "movingRight"
    var ActiveHammer: String = "defaultActiveHammer"
    
    var playerAttacked = false
    var startGamePlay = false
    
//MARK: GAME PROPERITES
    
    struct TouchInfo {
        var location: CGPoint
        var time: TimeInterval
    }
    
    let playerCamera = SKCameraNode()
    let playerLight = SKLightNode()
    let startButton = SKSpriteNode(imageNamed: "startButton") //allows player to start game
   // var shuffleButton = SKSpriteNode(imageNamed: "shuffleButton") //allows player to shuffle colors available
    var highScore = UserDefaults().integer(forKey: "HIGHSCORE") //how we save highscore
    var heart: SKSpriteNode!
    var lvlExit: SKSpriteNode!
    var startGame = false //determines if game is started
    var lvlExitOpen = false
    var spotTaken: Int? //tracks if a player's card already exists in the current location disallowing spawn
    var finalScore = 0
    var pointsLabel = SKLabelNode(fontNamed: "ArialMT") //player's score
    var levelTimerLabel = SKLabelNode(fontNamed: "ArialMT")
    var playerHUD = SKReferenceNode()
    var selectedColor = SKSpriteNode(imageNamed: "default")
    var spiderCountLabel: SKLabelNode?
    
    public var spidersSmashedCount = 0
    public var nxtLvl = ""
    public var score = 0
    public var timeElapsed = 0
    public var highScoreLabel = SKLabelNode() //game's current highscore
    public var waveLevel = 1 //tracks current wave level, increases difficult as waves are completed
    
    var points: Int = 0 {
        didSet {
            pointsLabel.text = "Score: \(points)"
        }
    }
    
    public var levelTimerValue: Int = 0 {
        didSet {
            levelTimerLabel.text = "Time: \(levelTimerValue)"
        }
    }
    
    var spiderCount: Int = 0 {
        didSet {
        spiderCountLabel?.text = "Spiders Left: \(spiderCount)"
        }
    }
    
    var playerDamageMultiplier: Int = 1 {
        didSet {
            //What do you do here?
        }
    }
//MARK: OVERRIDES
    
    override func didMove(to view: SKView) {
        
        // Setup physics world's contact delegate
        physicsWorld.contactDelegate = self
        
        //Setup camera view
        self.camera = playerCamera
        
        //setup game
        setupGame()
        animations()
        
        //start game
        startGame = true
        startGamePlay = false
        
        //load spiders
        spiderWaveGenerator() //spawns spiders for each level with increasing amounts
        spawnBoss()
        
        playerAtlas.preload {
            print("player atlas loaded")
            
        }
    
        bossAtlas.preload {
            print("boss atlas loaded")
        }
        
        
        spiderAtlas.preload {
            print("spider atlas loaded")
        }
        
        hammerAtlas.preload {
            print("hammer atlas loaded")
            
        }
        
    }
    
    override func didSimulatePhysics() {
        
        //handles the player's healthbar display
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
            
        if ((node as? SKSpriteNode) != nil) && (node.name?.contains("Hammer") == true && node.name?.contains("attack") == false) {
            
            //player has selected a color
            selectedNode = node as? SKSpriteNode //sets node to selected node
            
            var hammerColor = "default" // sets the hammer color to a default color allowing for no color to be selected
            let cardNameComps = selectedNode?.texture?.description.components(separatedBy: "'") // separates texture into array of 3 components
            if cardNameComps?.count == 3 {
                hammerColor = cardNameComps![1] // second component of the arrary is the name of the texture which is pulled here and assigned as hammercolor
            } else if cardNameComps?.count == 1 {
                hammerColor = "" //if we can't do the above, we set an empty string for the color
            }
            
            //after getting the hammer color we can set it to the playerColor variable
            playerColor = hammerColor
            
        } else if ((node as? SKSpriteNode) != nil) && (node.name?.contains("attackButton") == true) {
            
            //stop the player's movement
            player.removeAction(forKey: "moving")
            for boss in bosses {
                let bossPlayerDistance = player.position.distance(point: (boss.position))
                
                if bossPlayerDistance < 65 && playerCoolDown < 1 {
                        //set the hammer animation direction
                  //  hammerAnimations(direction: PlayerDirection)
//                    playerAttacksBoss(boss: boss , player: player)
//                    print("Attack Boss!")
//
                    if PlayerDirection == "movingRight" || PlayerDirection == "movingUp" {
                        player.removeAction(forKey: "moving")
                      //  player.run(SKAction.animate(with: playerAttackRightArray, timePerFrame: 0.1))
                        playerAttacksBoss(boss: boss, player: player)
                        
                    } else if PlayerDirection == "movingLeft" || PlayerDirection == "movingDown" {
                        player.removeAction(forKey: "moving")
                      //  player.run(SKAction.animate(with: playerAttackLeftArray, timePerFrame: 0.1))
                        playerAttacksBoss(boss: boss, player: player)
                        
                    }
                } else {
                   
                }
            }
            
            // look at all the spiders in the level
            for spider in spiders {
                
                let spiderPlayerDistance = player.position.distance(point: spider.position) // distance between spider and player
                
                
                
                
                //determine if the player is close enough to attack and if the player has selected the correct color axe
                if spiderPlayerDistance < 35 && playerCoolDown < 1 {
                    //set the hammer animation direction
                 //   hammerAnimations(direction: PlayerDirection)
                    if PlayerDirection == "movingRight" || PlayerDirection == "movingUp" {
                        player.removeAction(forKey: "moving")
                      //  player.run(SKAction.animate(with: playerAttackRightArray, timePerFrame: 0.1))
                        playerAttacksSpider(spider: spider, player: player, color: playerColor)
                        
                    } else if PlayerDirection == "movingLeft" || PlayerDirection == "movingDown" {
                        player.removeAction(forKey: "moving")
                     //   player.run(SKAction.animate(with: playerAttackLeftArray, timePerFrame: 0.1))
                        playerAttacksSpider(spider: spider, player: player, color: playerColor)
                        
                    }
                } else if spiderPlayerDistance > 35 && playerCoolDown < 1 {
                    
                //    hammerAnimations(direction: PlayerDirection)
                    player.removeAction(forKey: "moving")
                    if PlayerDirection == "movingRight" || PlayerDirection == "movingUp" {
                        player.removeAction(forKey: "moving")
                        player.run(SKAction.animate(with: playerAttackRightArray, timePerFrame: 0.1))
                    } else if PlayerDirection == "movingLeft" || PlayerDirection == "movingDown" {
                        player.removeAction(forKey: "moving")
                        player.run(SKAction.animate(with: playerAttackLeftArray, timePerFrame: 0.1))
                    }
                }
//                else if spider.name?.contains(playerColor) == false && playerCoolDown < 1 {
//                    print("Wrong Color Axe!")
//                 //   hammerAnimations(direction: PlayerDirection)
//                    player.removeAction(forKey: "moving")
//                    if PlayerDirection == "movingRight" || PlayerDirection == "movingUp" {
//                        player.removeAction(forKey: "moving")
//                        player.run(SKAction.animate(with: playerAttackRightArray, timePerFrame: 0.1))
//                    } else if PlayerDirection == "movingLeft" || PlayerDirection == "movingDown" {
//                        player.removeAction(forKey: "moving")
//                        player.run(SKAction.animate(with: playerAttackLeftArray, timePerFrame: 0.1))
//                    }
//                }
                else if playerCoolDown > 0 {
                    
                }
            }
            playerCoolDown = 1
            
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //track the touch as it is moved across the screen. If the selected node is not nil
        //we set the node's position to the location of the touch.
    
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //if the game has started - handle updates for game play.
        if startGame == true && startGamePlay == true {

            updatePlayer()
            updateSpider()
            updateBoss()
            
            if bossCount == 0 {
                lvlExit.color = .green
                lvlExitOpen = true
            } else if bossCount > 0 {
                lvlExit.color = .red
                lvlExitOpen = false
            }
        }
    }
    
//MARK: GAME METHODS
    
    func setupGame() {
        
        //add player
        if let somePlayer:Hero = self.childNode(withName: "player") as? Hero {
            player = somePlayer
        }
        player.name = "hero"
        player.heroMaxDamage = 10
        player.heroMinDamage = 3
        player.heroMaxHealth = 500
        player.zPosition = 3
        player.lightingBitMask = 5
        player.shadowedBitMask = 0
        player.shadowCastBitMask = 0
        
        
        //Add player's heads up display
        playerHUD = player.childNode(withName: "HUD") as! SKReferenceNode
        
        //add camera
        playerCamera.position = (player.position)
        playerCamera.xScale = 1.0
        playerCamera.yScale = 1.0
        addChild(playerCamera)
        
        //add light
        playerLight.position = (player.position)
        playerLight.falloff = 1.25
        playerLight.lightColor = SKColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0)
        playerLight.isEnabled = true
        playerLight.categoryBitMask = 5
        playerLight.zPosition = 1
        addChild(playerLight)
        
        //players health bar
        healthBar.position = CGPoint(x: 0, y: 75)
        healthBar.zPosition = 3
        playerHUD.addChild(healthBar)
        
        
        //add default active hammer
        activeHammer.position = CGPoint(x: 15, y: 5)
        activeHammer.size = CGSize(width: 16.5, height: 27.5)
        activeHammer.name = "Hammer"
        activeHammer.texture = hammerAtlas.textureNamed("defaultHammerRight")
        activeHammer.zPosition = 2
       // player.addChild(activeHammer)
        
        //add ScoreLabel
        pointsLabel.text = "Score: \(points)"
        pointsLabel.zPosition = 3
        pointsLabel.fontSize = 15
        pointsLabel.position = CGPoint(x: -69.5, y: -26.5)
        // playerHUD.addChild(pointsLabel)
        
        //spiderCountLabel
        spiderCountLabel?.text = "Spiders Left: \(spiderCount)"
        spiderCountLabel?.zPosition = 3
        spiderCountLabel?.fontName = "Helvetica Neue Condensed Bold"
        spiderCountLabel?.fontSize = 15
        spiderCountLabel?.position = CGPoint(x: 53.476, y: -26.5)
        // playerHUD.addChild(spiderCountLabel!)
        
        //Set the background
        let background = SKSpriteNode(imageNamed: "background")
        background.zPosition = -1
        background.size = frame.size
        background.position = CGPoint(x: 0.5, y: 0.5)
        background.lightingBitMask = 5
        background.normalTexture = background.texture?.generatingNormalMap(withSmoothness: 0.2, contrast: 0.2)
        // addChild(background)
        
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
        
        //add level timer
        levelTimerLabel.fontColor = SKColor.green
        levelTimerLabel.fontSize = 12
        levelTimerLabel.zPosition = 10
        levelTimerLabel.position = CGPoint(x: 0, y: 0)
        levelTimerLabel.text = "Time left: \(levelTimerValue)"
       // addChild(levelTimerLabel)
        
        //start timer
        let wait = SKAction.wait(forDuration: 0.5) //change countdown speed here
        let block = SKAction.run({
            [unowned self] in
            
            self.levelTimerValue += 1
            
        })
        //start timer
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
        
        
        spiderDamageMultiplier = self.userData?.value(forKey: "spiderDamageMultiplier") as! Double
        //spiderDamageMultiplier = spiderDamageMultiplier + spiderDamageMultiplier * 0.2
        userData?.setObject(spiderDamageMultiplier, forKey: "spiderDamageMultiplier" as NSCopying)
        
        spiderHealthMultiplier = self.userData?.value(forKey: "spiderHealthMultiplier") as! Double
        //spiderHealthMultiplier = spiderHealthMultiplier + spiderHealthMultiplier * 0.35
        userData?.setObject(spiderHealthMultiplier, forKey: "spiderHealthMultiplier" as NSCopying)
        
        print("CoreGame")
        print("Player Max Damage: \(playerMaxDamage)")
        print("Player Min Damage: \(playerMinDamage)")
        print("Player Max Health: \(playerMaxHealth)")
        print("Spider Damage Multiplier: \(spiderDamageMultiplier)")
        print("Spider Health Multiplier: \(spiderHealthMultiplier)")
        
    }
    
    func animations() {
        
        
        
        for i in 0...(playerRunRightAtlas.textureNames.count - 1) {
            
            let Name = "\(i)"
            playerRunRightArray.append(SKTexture(imageNamed: "right\(Name)"))
        }
        
        for i in 0...(playerRunLeftAtlas.textureNames.count - 1) {
            
            let Name = "\(i)"
            playerRunLeftArray.append(SKTexture(imageNamed: Name))
        }
        
        for i in 0...(playerAttackRightAtlas.textureNames.count - 1) {
            
            let Name = "\(i)"
            playerAttackRightArray.append(SKTexture(imageNamed: "attackRight\(Name)"))
        }
        
        for i in 0...(playerAttackLeftAtlas.textureNames.count - 1) {
            
            let Name = "\(i)"
            playerAttackLeftArray.append(SKTexture(imageNamed: "leftattack\(Name)"))
        }
        
        playerRight = SKAction.moveBy(x: 40, y: 0, duration: 0.6)
        playerLeft = SKAction.moveBy(x: -40, y: 0, duration: 0.6)
        playerDown = SKAction.moveBy(x: 0, y: -40, duration: 0.6)
        playerUp = SKAction.moveBy(x: 0, y: 40, duration: 0.6)
        
    }
    
    
    //MARK: PLAYER METHODS
    func updatePlayer() {
        
        playerLight.position = player.position //updates player's light
        playerCamera.position = player.position //updates player's camera

        switch PlayerDirection {
            case "movingRight" :
                hammerDirection = "HammerRight"
            //    player.run(SKAction.animate(with: playerAttackRightArray, timePerFrame: 0.6))
            //    activeHammer.texture = hammerAtlas.textureNamed("\(playerColor)"+"\(hammerDirection)")
                activeHammer.position = CGPoint(x: 15, y: 3)
            case "movingLeft" :
                hammerDirection = "HammerLeft"
            //    player.run(SKAction.animate(with: playerAttackLeftArray, timePerFrame: 0.6))
            //    activeHammer.texture = hammerAtlas.textureNamed("\(playerColor)"+"\(hammerDirection)")
                activeHammer.position = CGPoint(x: -15, y: 5)
            case "movingDown" :
                hammerDirection = "HammerDown"
           //     activeHammer.texture = hammerAtlas.textureNamed("\(playerColor)"+"\(hammerDirection)")
           //     player.run(SKAction.animate(with: playerAttackLeftArray, timePerFrame: 0.6))
                activeHammer.position = CGPoint(x: -16, y: 5)
            case "movingUp" :
                hammerDirection = "HammerUp"
            //    activeHammer.texture = hammerAtlas.textureNamed("\(playerColor)"+"\(hammerDirection)")
            //    player.run(SKAction.animate(with: playerAttackRightArray, timePerFrame: 0.6))
                activeHammer.position = CGPoint(x: 15, y: 4)
            default : break
        }
        
        healthBar.progress = (CGFloat(playerHealth / playerMaxHealth))
        
        if playerCoolDown > 0 && playerCoolDownStarted == false {
            
            let wait = SKAction.wait(forDuration: 0.7) //change countdown speed here
            let block = SKAction.run({
                [unowned self] in
                
                self.playerCoolDown -= 1
                
            })
            
            //start timer
            let sequence = SKAction.sequence([wait,block])
            
            
            playerCoolDownStarted = true
            run(SKAction.repeatForever(sequence), withKey: "playerCoolDown")
        }
        
        if playerCoolDown < 1 {
            removeAction(forKey: "playerCoolDown")
            playerCoolDownStarted = false
            playerCoolDown = 0
        }
        
        // handles game over if the player dies.
        if playerHealth < 1 {
            gameOver()
        }
        
    }
    
    
    
    //used for healing player if a heart is collected
    func gainLife() {

        playerHealth = playerHealth + 200
        
        if playerHealth > playerMaxHealth {
            playerHealth = playerMaxHealth
        }
        print("Current Health: \(playerHealth)")
    }
    
    //switch out player's textures depending on swiped movement
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                removeAction(forKey: "moving")
                player.run(SKAction.repeatForever(playerRight), withKey: "moving")
                player.run(SKAction.repeatForever(SKAction.animate(with: playerRunRightArray, timePerFrame: 0.1)))
                PlayerDirection = "movingRight"
            case UISwipeGestureRecognizerDirection.down:
                removeAction(forKey: "moving")
                player.run(SKAction.repeatForever(playerDown), withKey: "moving")
                player.run(SKAction.repeatForever(SKAction.animate(with: playerRunLeftArray, timePerFrame: 0.1)))
              //  player.texture = playerAtlas.textureNamed("player-down")
                PlayerDirection = "movingDown"
            case UISwipeGestureRecognizerDirection.left:
                removeAction(forKey: "moving")
                player.run(SKAction.repeatForever(playerLeft), withKey: "moving")
                player.run(SKAction.repeatForever(SKAction.animate(with: playerRunLeftArray, timePerFrame: 0.1)))
                PlayerDirection = "movingLeft"
            case UISwipeGestureRecognizerDirection.up:
                removeAction(forKey: "moving")
                player.run(SKAction.repeatForever(playerUp), withKey: "moving")
                player.run(SKAction.repeatForever(SKAction.animate(with: playerRunRightArray, timePerFrame: 0.1)))
              //  player.texture = playerAtlas.textureNamed("player-up")
                PlayerDirection = "movingUp"
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
        let randomSpiderNumber = Int(arc4random_uniform(UInt32(spiders.count)))
        
        //returns a spider
        return spiders[randomSpiderNumber]
        
    }
    
    func spawnBoss() {
        let zazuBossSpider = Boss(bossType: .Zazu)
        let blubBossSpider = Boss(bossType: .Blub)
        let zapoBossSpider = Boss(bossType: .Zapo)
        
        zazuBossSpider.name = "ZazuSpider"
        blubBossSpider.name = "BlubSpider"
        zapoBossSpider.name = "ZapoSpider"
        
        let randomBosses = [zazuBossSpider, zapoBossSpider, blubBossSpider]
        
        let randomBossNumber = Int(arc4random_uniform(UInt32(randomBosses.count)))
        let randomBoss = randomBosses[randomBossNumber]
        randomBoss.bossCoolDownCounter = 0
        randomBoss.bossCoolDown = false
        randomBoss.bossAttacking = false
        randomBoss.bossCoolDownStarted = false
        randomBoss.zPosition = 4
        randomBoss.physicsBody = SKPhysicsBody(texture: randomBoss.frontTexture, size: randomBoss.size)
        randomBoss.physicsBody?.contactTestBitMask = 1
        randomBoss.physicsBody?.categoryBitMask = 5
        randomBoss.physicsBody?.mass = 5.0
        randomBoss.physicsBody?.restitution = 0.2
        randomBoss.physicsBody?.isDynamic = true
        randomBoss.physicsBody?.affectedByGravity = false
        randomBoss.lightingBitMask = 5
        randomBoss.shadowedBitMask = 5
        randomBoss.bossHealth = randomBoss.bossHealth * spiderHealthMultiplier
    
        let playerSpiderDistance = player.position.distance(point: randomBoss.position)
        
        if positionIsEmpty(point: (randomBoss.position)) == 2 && playerSpiderDistance > 300 {
            addChild(randomBoss)
            bossCount += 1
            bosses.append(randomBoss)
        } else {
            spawnBoss()
        }
    }
    
    func spawnSpiders() {
        
            spawnSpider = createSpider() as? Spider
            spawnSpider?.spiderCoolDownCounter = 0
            spawnSpider?.spiderAttacking = false
            spawnSpider?.spiderCoolDown = false
            spawnSpider?.spiderCoolDownStarted = false
            spawnSpider?.position = spiderSpawnPosition()
            spawnSpider?.zPosition = 2
            spawnSpider?.physicsBody = SKPhysicsBody(texture: (spawnSpider?.frontTexture)!, size: (spawnSpider?.size)!)
            spawnSpider?.physicsBody?.contactTestBitMask = 1
            spawnSpider?.physicsBody?.categoryBitMask = 5
            spawnSpider?.physicsBody?.mass = 3.5
            spawnSpider?.physicsBody?.restitution = 0.2
            spawnSpider?.physicsBody?.isDynamic = true
            spawnSpider?.physicsBody?.affectedByGravity = false
            spawnSpider?.lightingBitMask = 5
            spawnSpider?.shadowedBitMask = 5
        
        spawnSpider?.spiderHealth = (spawnSpider?.spiderHealth)! * spiderHealthMultiplier
        print("Spider health: \(String(describing: spawnSpider?.spiderHealth))")
        
        let playerSpiderDistance = player.position.distance(point: (spawnSpider?.position)!)
        
        // ensures spiders don't spawn ontop of obsticales within the map
        if positionIsEmpty(point: (spawnSpider?.position)!) == 2 && playerSpiderDistance > 200 {
                addChild(spawnSpider!)
                spiders.append(spawnSpider!)
                spiderCount += 1
                spiderCountLabel?.text = "Spiders Left: \(self.spiderCount)"
            } else {
                spawnSpiders()
            }
        
    }
    
    func spiderSpawnPosition() -> CGPoint {
        let height = frame.height / 2
        let width = frame.width / 2
        
        let randomHeight = CGFloat(arc4random()).truncatingRemainder(dividingBy: height)
        let randomWidth = CGFloat(arc4random()).truncatingRemainder(dividingBy: width)
        
        let spiderPOS = makePositiveorNegative(height: randomHeight, width: randomWidth)
        
        return spiderPOS //returns a random position to for a spider to be spawned
        
    }
    
    
    
    func makePositiveorNegative(height: CGFloat, width: CGFloat) -> CGPoint {
        //allows the entire map to be a spawn location instead of just the positive quadrents.
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
        
        //determines how many spiders to spawn
        waveLevel = self.userData?.value(forKey: "waveLevel") as! Int
        print("wave level: \(waveLevel)")
        let levelMultipler = waveLevel
        let spidersToSpawn = 5 * levelMultipler
        
        
        while spawnAmount < spidersToSpawn {
            spawnSpiders()
            spawnAmount += 1
        }
        
        startGamePlay = true
        print("\(startGamePlay)")
    }
    
    func spiderProjectileGenerator(initialPosition: CGPoint, targetPosition: CGPoint) {
        print("FIRE")
        //generates a projectile from spiders - Work in progress
        let projectile = SKSpriteNode(imageNamed: "spiderProjectile")
        let target = targetPosition
        projectile.name = "spiderProjectile"
        projectile.zPosition = 10
        projectile.size = CGSize(width: 5, height: 5)
        projectile.position = initialPosition
        projectile.physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
        projectile.physicsBody?.affectedByGravity = false
        projectile.physicsBody?.contactTestBitMask = 5
        projectile.physicsBody?.collisionBitMask = 1
        projectile.physicsBody?.categoryBitMask = 1
        
        let projectileMove = SKAction.move(to: target, duration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let projectileSequence = SKAction.sequence([projectileMove, fadeOut])
        
        let spiderProjectileChance = arc4random_uniform(100) + 1
        
        if spiderProjectileChance > 99 {
            self.addChild(projectile)
            projectile.run(projectileSequence, completion: projectile.removeFromParent)
        }
        
    }
    
    func updateSpider() {
    
        //handles updating all spider movements and attacks.
        
            for spider in spiders {
                
                let spiderSpeed = CGFloat(0.8)
                let dx = player.position.x - (spider.position.x)
                let dy = player.position.y - (spider.position.y)
                let angle = atan2(dy, dx)
                let vx = cos(angle) * spiderSpeed
                let vy = sin(angle) * spiderSpeed
                let spiderMove = SKAction.moveBy(x: vx, y: vy, duration: 0.5)
                let spiderPlayerDistance = player.position.distance(point: spider.position)
                let wait = SKAction.wait(forDuration: 0.3) //change countdown speed here
                let block = SKAction.run({ spider.spiderCoolDownCounter -= 1 })
                let sequence = SKAction.sequence([wait,block])
                
                spider.zRotation = angle
                
                if spiderPlayerDistance > 35 && spiderPlayerDistance < 220 && spider.moving == false {
                    spider.spiderAction = "spiderMoves"
                } else if spiderPlayerDistance < 35 && spider.spiderCoolDownCounter == 0 && spider.spiderCoolDownStarted == false {
                    spider.spiderAction = "spiderAttacks"
                } else if spider.spiderCoolDownCounter >= 1 && spider.spiderCoolDownStarted == false {
                    spider.spiderAction = "coolDown"
                } else if spider.spiderCoolDownCounter <= 0 && spider.spiderCoolDownStarted == true {
                    spider.spiderAction = "resetCoolDown"
                }
                
                switch spider.spiderAction {
                    case "spiderMoves":
                        spider.moving = true
                        spider.run(spiderMove, completion: {spider.moving = false}) //spider moving
                    case "spiderAttacks":
                        spider.spiderCoolDownCounter = 5
                        spider.run(SKAction.repeatForever(sequence), withKey: "spiderCoolDown")
                        spiderAttacksPlayer(spider: spider, player: self.player, color: self.playerColor)
                    case "coolDown" :
                        spider.spiderCoolDownStarted = true
                    case "resetCoolDown" :
                        spider.removeAction(forKey: "spiderCoolDown")
                        spider.spiderCoolDownCounter = 0
                        spider.spiderCoolDownStarted = false
                    default: break
                }
        }
    }
    
    func updateBoss() {
    
        for boss in bosses {
            
            let bossSpeed = CGFloat(0.8)
            let dx = player.position.x - (boss.position.x)
            let dy = player.position.y - (boss.position.y)
            let angle = atan2(dy, dx)
            let vx = cos(angle) * bossSpeed
            let vy = sin(angle) * bossSpeed
            let bossMove = SKAction.moveBy(x: vx, y: vy, duration: 0.5)
            let bossPlayerDistance = player.position.distance(point: boss.position)
            let wait = SKAction.wait(forDuration: 0.3) //change countdown speed here
            let block = SKAction.run({ boss.bossCoolDownCounter -= 1 })
            let sequence = SKAction.sequence([wait,block])
            
            boss.zRotation = angle
            
            if bossPlayerDistance > 65 && bossPlayerDistance < 220 && boss.moving == false {
                boss.bossAction = "bossMoves"
            } else if bossPlayerDistance < 65 && boss.bossCoolDownCounter == 0 && boss.bossCoolDownStarted == false {
                boss.bossAction = "bossAttacks"
            } else if boss.bossCoolDownCounter >= 1 && boss.bossCoolDownStarted == false {
                boss.bossAction = "coolDown"
            } else if boss.bossCoolDownCounter <= 0 && boss.bossCoolDownStarted == true {
                boss.bossAction = "resetCoolDown"
            }
            
            switch boss.bossAction {
            case "bossMoves":
                boss.moving = true
                boss.run(bossMove, completion: {boss.moving = false}) //spider moving
            case "bossAttacks":
                boss.bossCoolDownCounter = 7
                boss.run(SKAction.repeatForever(sequence), withKey: "bossCoolDown")
                bossAttacksPlayer(spider: boss, player: self.player, color: self.playerColor)
            case "coolDown" :
                boss.bossCoolDownStarted = true
            case "resetCoolDown" :
                boss.removeAction(forKey: "bossCoolDown")
                boss.bossCoolDownCounter = 0
                boss.bossCoolDownStarted = false
            default: break
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
    
    //MARK: COMBAT FUNCTIONS
    
    func playerDamage() -> Double {
        //random damage selected based off player's max damage number
        var randomDamage = Double(arc4random_uniform(UInt32(playerMaxDamage)) + UInt32(playerMinDamage))
        
        //allow for block chance
        let blockChance = Int(arc4random_uniform(100)+1)
        
        //allw for crit chance
        let critChance = Int(arc4random_uniform(100)+1)
        
        //if block chance damage dealt is zero
        if blockChance < 8 {
            randomDamage = 0
        } else if blockChance > 8 && critChance > 95 && randomDamage > playerMaxDamage * 0.85 {
            playerCrit = true
            randomDamage = randomDamage * 3
        } else {
          return randomDamage
        }
        
        return randomDamage //returns the random damage
        
    }
    
    func spiderDamage() -> Int {
        
        //essentially the same concept as player's damage function above just for the spiders.
        
        var randomDamage = Int(arc4random_uniform(UInt32(spiderMaxDamage))+2)
        
        let blockChance = Int(arc4random_uniform(100)+1)
        let critChance = Int(arc4random_uniform(100)+1)
        
        if blockChance < 10 {
            randomDamage = 0
        } else if blockChance > 10 && critChance > 80 && randomDamage > (spiderMaxDamage * Int(0.85)) {
            spiderCrit = true
            randomDamage = randomDamage * Int(1.5)
        } else {
            return randomDamage * Int(spiderDamageMultiplier)
        }
        return randomDamage * Int(spiderDamageMultiplier)
    }
    
    func damageAnimationCounter(position: CGPoint) -> SKLabelNode {
        
        let damageLabel = SKLabelNode()
        let position = CGPoint(x: position.x, y: position.y + 40)
        
        damageLabel.fontSize = 14
        damageLabel.fontColor = SKColor.white
        damageLabel.fontName = "Futura-CondensedExtraBold"
        damageLabel.position = position
        damageLabel.zPosition = 1500
        damageLabel.name = "damageLabel"
        
        return damageLabel
        
    }
    
    func playerAttacksBoss(boss: Boss, player: SKSpriteNode) {
        
        let wait = SKAction.wait(forDuration: 0.2)
        let hitAnimation = SKEmitterNode(fileNamed: "GreenScatter")
        
        let attackDamage = playerDamage()
        let damage = damageAnimationCounter(position: boss.position)
        let hitAn = hitAnimation
        
      //  hammerAnimations(direction: PlayerDirection)
        if PlayerDirection == "movingRight" || PlayerDirection == "movingUp" {
            player.removeAction(forKey: "moving")
            player.run(SKAction.animate(with: playerAttackRightArray, timePerFrame: 0.1))
        } else if PlayerDirection == "movingLeft" || PlayerDirection == "movingDown" {
            player.removeAction(forKey: "moving")
            player.run(SKAction.animate(with: playerAttackLeftArray, timePerFrame: 0.1))
        }
        
        hitAn?.position = (boss.position)
        addChild((hitAn)!)
        hitAn?.run(wait, completion: {hitAn?.removeAllActions(); hitAn?.removeFromParent()})
        
        if attackDamage == 0 {
            damage.text = "BLOCK"
            damage.fontSize = 18
            damage.fontColor = SKColor.blue
            addChild(damage)
            damage.run(SKAction.moveBy(x: -5, y: 15, duration: 0.3), completion: {damage.run(SKAction.fadeOut(withDuration: 0.7), completion: { damage.removeFromParent()})})
        } else if playerCrit == false {
            boss.bossHealth -= attackDamage
            damage.text = "\(attackDamage)"
            damage.fontColor = SKColor.white
            addChild(damage)
            damage.run(SKAction.moveBy(x: -5, y: 15, duration: 0.3), completion: {damage.run(SKAction.fadeOut(withDuration: 0.7), completion: { damage.removeFromParent()})})
        } else if playerCrit == true {
            boss.bossHealth -= attackDamage
            damage.text = "\(attackDamage)"
            damage.fontSize = 20
            damage.fontColor = SKColor.green
            addChild(damage)
            damage.run(SKAction.moveBy(x: -5, y: 20, duration: 0.6), completion: {damage.run(SKAction.fadeOut(withDuration: 1.2), completion: { damage.removeFromParent()})})
            playerCrit = false
        }
        
        // boss dies
        if (boss.bossHealth) < 1 {
            let index = bosses.index(of: (boss))
            
            if index != nil {
                bosses.remove(at: index!)
                bloodSplatter(pos: (boss.position))
                points += 50
                spidersSmashedCount += 1
                bossCount -= 1
                boss.removeFromParent()
                
                //if spider is still alive
            } else {
            }
            
        } else if boss.bossHealth > 0 {
            
            //Boss Attacks
            
        }
    }
    
    func playerAttacksSpider(spider: Spider, player: SKSpriteNode, color: String) {
        
        let player = player
        let color = color
        let wait = SKAction.wait(forDuration: 0.2)
        let hitAnimation = SKEmitterNode(fileNamed: "GreenScatter")
        
        //Player Attacks Spider
     //   if (spider.name?.contains(color))! {
        
            let attackDamage = playerDamage()
            let damage = damageAnimationCounter(position: spider.position)
            let hitAn = hitAnimation
            
        //    hammerAnimations(direction: PlayerDirection)
            if PlayerDirection == "movingRight" || PlayerDirection == "movingUp" {
                player.removeAction(forKey: "moving")
                player.run(SKAction.animate(with: playerAttackRightArray, timePerFrame: 0.1))
            } else if PlayerDirection == "movingLeft" || PlayerDirection == "movingDown" {
                player.removeAction(forKey: "moving")
                player.run(SKAction.animate(with: playerAttackLeftArray, timePerFrame: 0.1))
            }
            
            hitAn?.position = (spider.position)
            addChild((hitAn)!)
            hitAn?.run(wait, completion: {hitAn?.removeAllActions(); hitAn?.removeFromParent()})
            
            if attackDamage == 0 {
                
                damage.text = "BLOCK"
                damage.fontSize = 18
                damage.fontColor = SKColor.blue
                addChild(damage)
                damage.run(SKAction.moveBy(x: -5, y: 15, duration: 0.3), completion: {damage.run(SKAction.fadeOut(withDuration: 0.7), completion: { damage.removeFromParent()})})
            } else if playerCrit == false {
                spider.spiderHealth -= attackDamage
                damage.text = "\(attackDamage)"
                damage.fontColor = SKColor.white
                addChild(damage)
                damage.run(SKAction.moveBy(x: -5, y: 15, duration: 0.3), completion: {damage.run(SKAction.fadeOut(withDuration: 0.7), completion: { damage.removeFromParent()})})
            } else if playerCrit == true {
                spider.spiderHealth -= attackDamage
                damage.text = "\(attackDamage)"
                damage.fontSize = 20
                damage.fontColor = SKColor.green
                addChild(damage)
                damage.run(SKAction.moveBy(x: -5, y: 20, duration: 0.6), completion: {damage.run(SKAction.fadeOut(withDuration: 1.2), completion: { damage.removeFromParent()})})
                playerCrit = false
            }
            
            // spider dies
            if (spider.spiderHealth) < 1 {
                let index = spiders.index(of: (spider))
                
                if index != nil {
                    spiders.remove(at: index!)
                    bloodSplatter(pos: (spider.position))
                    points += 10
                    spidersSmashedCount += 1
                    spiderCount -= 1
                    spider.removeFromParent()
                    
                    //if spider is still alive
                } else {
                    
                }
                
            } else if spider.spiderHealth > 0 {
                
                //Spider count attack!
                self.spiderAttacksPlayer(spider: spider, player: player, color: color)
                
            }
        //}
    }
    
    func spiderAttacksPlayer(spider: SKSpriteNode, player: SKSpriteNode, color: String) {
        
        let player = player
      
        let spiderInitalPosition = spider.position
        let spiderAttack = SKAction.move(to: player.position, duration: 0.25)
        let spiderReturn = SKAction.move(to: spiderInitalPosition, duration: 0.25)
        let spiderAttackSequence = SKAction.sequence([spiderAttack, spiderReturn])
        
        spider.run(spiderAttackSequence)
        
                let spiderAttackDamage = self.spiderDamage()
                let damage = self.damageAnimationCounter(position: player.position)
                
                if spiderAttackDamage == 0 {
                    
                    damage.text = "BLOCK"
                    damage.fontSize = 18
                    damage.fontColor = SKColor.red
                    self.addChild(damage)
                    damage.run(SKAction.moveBy(x: 5, y: 15, duration: 0.3), completion: {damage.run(SKAction.fadeOut(withDuration: 0.7), completion: { damage.removeFromParent()})})
                } else if self.spiderCrit == false {
                    self.playerHealth -= Double(spiderAttackDamage)
                    damage.text = "\(spiderAttackDamage)"
                    damage.fontColor = SKColor.red
                    self.addChild(damage)
                    damage.run(SKAction.moveBy(x: 5, y: 15, duration: 0.3), completion: {damage.run(SKAction.fadeOut(withDuration: 0.7), completion: { damage.removeFromParent()})})
                } else if self.spiderCrit == true {
                    self.playerHealth -= Double(spiderAttackDamage)
                    damage.text = "\(spiderAttackDamage)"
                    damage.fontSize = 18
                    damage.fontColor = SKColor.red
                    self.addChild(damage)
                    damage.run(SKAction.moveBy(x: 5, y: 20, duration: 0.6), completion: {damage.run(SKAction.fadeOut(withDuration: 1.2), completion: { damage.removeFromParent()})})
                    self.spiderCrit = false
                }
    }
    
    func bossAttacksPlayer(spider: Boss, player: SKSpriteNode, color: String) {
        
        let player = player
        let boss = spider
        let spiderInitalPosition = boss.position
        let spiderAttack = SKAction.move(to: player.position, duration: 0.25)
        let spiderReturn = SKAction.move(to: spiderInitalPosition, duration: 0.25)
        let spiderAttackSequence = SKAction.sequence([spiderAttack, spiderReturn])
        let bossDamangeMultiplier = 3
        
        boss.run(spiderAttackSequence)
        
        let spiderAttackDamage = self.spiderDamage() * bossDamangeMultiplier
        let damage = self.damageAnimationCounter(position: player.position)
        
        if spiderAttackDamage == 0 {
            
            damage.text = "BLOCK"
            damage.fontSize = 18
            damage.fontColor = SKColor.red
            self.addChild(damage)
            damage.run(SKAction.moveBy(x: 5, y: 15, duration: 0.3), completion: {damage.run(SKAction.fadeOut(withDuration: 0.7), completion: { damage.removeFromParent()})})
        } else if self.spiderCrit == false {
            self.playerHealth -= Double(spiderAttackDamage)
            damage.text = "\(spiderAttackDamage)"
            damage.fontColor = SKColor.red
            self.addChild(damage)
            damage.run(SKAction.moveBy(x: 5, y: 15, duration: 0.3), completion: {damage.run(SKAction.fadeOut(withDuration: 0.7), completion: { damage.removeFromParent()})})
        } else if self.spiderCrit == true {
            self.playerHealth -= Double(spiderAttackDamage)
            damage.text = "\(spiderAttackDamage)"
            damage.fontSize = 18
            damage.fontColor = SKColor.red
            self.addChild(damage)
            damage.run(SKAction.moveBy(x: 5, y: 20, duration: 0.6), completion: {damage.run(SKAction.fadeOut(withDuration: 1.2), completion: { damage.removeFromParent()})})
            self.spiderCrit = false
        }
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
        
        let hitAnimationRight = SKAction.rotate(byAngle: -1.2, duration: 0.15)
        let hitAnimationLeft = SKAction.rotate(byAngle: 1.2, duration: 0.15)
        let wait = SKAction.wait(forDuration: 0.1)
        let hitAnimationReturnRight = SKAction.rotate(byAngle: 1.2, duration: 0.15)
        let hitAnimationReturnLeft = SKAction.rotate(byAngle: -1.2, duration: 0.15)
        let hitAnimationSequenceRight = SKAction.sequence([hitAnimationRight, wait, hitAnimationReturnRight])
        let hitAnimationSequenceLeft = SKAction.sequence([hitAnimationLeft, wait, hitAnimationReturnLeft])
        
        switch direction {
            case "movingRight" : activeHammer.run(hitAnimationSequenceRight)
            case "movingLeft" : activeHammer.run(hitAnimationSequenceLeft)
            case "movingDown" : activeHammer.run(hitAnimationSequenceLeft)
            case "movingUp" : activeHammer.run(hitAnimationSequenceRight)
            default : break
        }
        
    }
    
    func positionIsEmpty(point: CGPoint) -> Int {
        
        self.enumerateChildNodes(withName: "horizWall", using: {
            node, stop in
            
            let dot = node as! SKSpriteNode
            if (dot.frame.contains(point)) {
                
                self.spotTaken = 1
            } else {
                self.spotTaken = 2
            }
        })
        
        return spotTaken!
        
    }
    
    
    func gameOver() {
        
        finalScore = (points * spidersSmashedCount)
        startGame = false
        startGamePlay = false
        
        nxtLvl = "LevelEnd"
        
        if finalScore > UserDefaults().integer(forKey: "HIGHSCORE") {
            saveHighScore()
        }
        
        
      
        
        
        goTo(nextLevel: SceneIdentifier(rawValue: nxtLvl)!)
        
//        let gameOver = GameOverScene(size: (self.scene?.size)!)
//        //let gameOver = GameOverScene(fileNamed: "GameOverScene")
//        gameOver.scaleMode = .aspectFill
//        gameOver.userData = NSMutableDictionary()
//        gameOver.userData?.setObject(finalScore, forKey: "score" as NSCopying)
//        gameOver.userData?.setObject(highScore, forKey: "HS" as NSCopying)
//
//        self.view?.presentScene(gameOver)
        
    }
    
    func levelEnd() {
        
        finalScore = (points * spidersSmashedCount)
        startGame = false
        startGamePlay = false
        
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
    
    func goTo(nextLevel: SceneIdentifier) {
        
        // pass key for next level which is passed from didMove to view of previous level
        print("loading scene for \(nxtLvl)")
//        loadScene(withIdentifier: SceneIdentifier(rawValue: nxtLvl)!)
        startGamePlay = false
        
        loadScene(withIdentifier: SceneIdentifier(rawValue: nxtLvl)!, currentScore: points, currentTime: levelTimerValue, currentPlayerHealth: playerHealth, spidersSmashed: spidersSmashedCount, waveLevel: waveLevel, playerMaxDamage: playerMaxDamage, playerMinDamage: playerMinDamage, playerMaxHealth: playerMaxHealth, playerMultipler: playerDamageMultiplier, spiderDamageMultiplier: spiderDamageMultiplier, spiderHealthMultiplier: spiderHealthMultiplier)
        
    }
    
    func goToTransition(nextLevel: SceneIdentifier) {
        
        print("Level Cleared   Go To Transition")
        
        loadScene(withIdentifier: SceneIdentifier(rawValue: "LevelTransition")!, currentScore: points, currentTime: levelTimerValue, currentPlayerHealth: playerHealth, spidersSmashed: spidersSmashedCount, waveLevel: waveLevel, playerMaxDamage: playerMaxDamage, playerMinDamage: playerMinDamage, playerMaxHealth: playerMaxHealth, playerMultipler: playerDamageMultiplier, spiderDamageMultiplier: spiderDamageMultiplier, spiderHealthMultiplier: spiderHealthMultiplier)
        
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
    
    public func saveHighScore() {
        UserDefaults.standard.set(finalScore, forKey: "HIGHSCORE")
    }
    
    
    
    
    
//MARK: GAME PHYSICS
    
    public func didBegin(_ contact: SKPhysicsContact) {
        // 1. Create local variables for two physics bodies
        
        var contactType:ContactType = .none
        var higherNode: SKSpriteNode?
        var lowerNode: SKSpriteNode?
        
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
            higherNode = contact.bodyA.node as! SKSpriteNode?
            lowerNode = contact.bodyB.node as! SKSpriteNode?
        } else if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            higherNode = contact.bodyB.node as! SKSpriteNode?
            lowerNode = contact.bodyA.node as! SKSpriteNode?
        } else {
            return
        }
        
        guard let h_node = higherNode, let l_node = lowerNode else {
            return
        }
        
        /*
         POSSIBLE CASES (firstBody vs secondBody)
         
         Spider hits Player L/H
         Spider hits wall L/H
         Spider hits boarder L/H
         Spider hits exit same
         
         Player hits Spider H/L
         Player hits wall L/H
         Player hits boarder L/H
         Player hits exit H/L
         Player hits heart H/L
         
         
         projectile - 1
         spiders - 3
         level exit - 3
         heart - 3
         player - 4
         hammer - 4
         wall - 5
         
         
 
         */
        
        if (l_node.name!.contains("Spider") && h_node.name!.contains("hero")) {
            contactType = .SpiderHitPlayer
        }
        else if (l_node.name!.contains("Spider") && h_node.name!.contains("Hammer")) {
            contactType = .PlayerHitSpider
        }
        else if (l_node.name!.contains("heart") && h_node.name!.contains("hero")) {
            contactType = .PlayerGetHearts
        }
        else if (l_node.name!.contains("Projectile") && h_node.name!.contains("hero")) {
            contactType = .SpiderProjectileHitsPlayer
        }
        else if (l_node.name!.contains("Projectile") && ((h_node.name!.contains("wall") == true) || h_node.name!.contains("boarder") == true)) {
            contactType = .SpiderProjectileHitsWall
        }
        else if (l_node.name!.contains("lvlExit") && h_node.name!.contains("hero")) {
            contactType = .PlayerExitsLevel
        }
            
        contactUpdate(lowNode: l_node, highNode: h_node, contactType: contactType)
        
    }
    
   
    
    
    func contactUpdate(lowNode: SKSpriteNode, highNode: SKSpriteNode, contactType: ContactType) {
        
        switch contactType{
            
        case .PlayerHitSpider: print("playerhitspider")
            
            
        case .SpiderHitPlayer: print("spiderhitplayer")
            
            

        
        case .SpiderProjectileHitsWall:
            lowNode.removeFromParent()
            
        
        case .SpiderProjectileHitsPlayer:
            
            lowNode.removeFromParent()
            playerHealth -= 2
            let damage = self.damageAnimationCounter(position: player.position)
            damage.text = "\(2)"
            damage.fontColor = SKColor.red
            self.addChild(damage)
            damage.run(SKAction.moveBy(x: 5, y: 15, duration: 0.3), completion: {damage.run(SKAction.fadeOut(withDuration: 0.7), completion: { damage.removeFromParent()})})
       
        case .PlayerGetHearts:
            gainLife()
            lowNode.removeFromParent()
        
        case .PlayerExitsLevel: if lvlExitOpen == false {
                            print("Kill more spiders")
                        } else if lvlExitOpen == true {
                            print("Advance to next level")
                            if nxtLvl != "GameOver" && nxtLvl != "LevelEnd" {
                                goToTransition(nextLevel: SceneIdentifier(rawValue: "LevelTransition")!)
                            } else if nxtLvl == "GameOver" {
                                nxtLvl = "LevelEnd"
                                gameOver()
                            } else if nxtLvl == "LevelEnd" {
                                levelEnd()
                            }
            
                        }
        
        case .none : break
            
        }
    }
}

extension CGPoint {
    func distance(point: CGPoint) -> CGFloat {
        return abs(CGFloat(hypotf(Float(point.x - x), Float(point.y - y))))
    }
}
