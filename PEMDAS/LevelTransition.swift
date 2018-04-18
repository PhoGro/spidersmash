//
//  GameOver.swift
//  PEMDAS
//
//  Created by John Davenport on 12/20/17.
//  Copyright © 2017 John Davenport. All rights reserved.
//


import SpriteKit
import GameplayKit

class LevelTransition: CoreGame {
    
    var buffOne: SKSpriteNode?
    var buffTwo: SKSpriteNode?
    var finalHighScore: SKLabelNode?
    var spidersSmashed: SKLabelNode?
    var timeTaken: SKLabelNode?
    var buffTwoSpawned = false
    //var highScoreLabel: SKLabelNode?
    var gameOverLabel: SKLabelNode?
  //  let background = SKSpriteNode(imageNamed: "background")
    
    override func didMove(to view: SKView) {
        
        print("Made it to level Transition")
        
        scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        waveLevel = self.userData?.value(forKey: "waveLevel") as! Int
        waveLevel += 1
        if waveLevel > 4 {
            waveLevel = 1
        }
        
        userData?.setObject(waveLevel, forKey: "waveLevel" as NSCopying)
        
        score =  self.userData?.value(forKey: "score") as! Int
        points = score
        
        timeElapsed = self.userData?.value(forKey: "LTV") as! Int
        levelTimerValue = timeElapsed
        
        spidersSmashedCount = self.userData?.value(forKey: "spidersSmashed") as! Int
        
        playerHealth = self.userData?.value(forKey: "playerHealth") as! Double
        
        playerMaxDamage = self.userData?.value(forKey: "playerMaxDamage") as! Int
        playerMinDamage = self.userData?.value(forKey: "playerMinDamage") as! Int
        playerMaxHealth = self.userData?.value(forKey: "playerMaxHealth") as! Double
        spiderDamageMultiplier = self.userData?.value(forKey: "spiderDamageMultiplier") as! Double

        spiderDamageMultiplier = spiderDamageMultiplier + spiderDamageMultiplier * 0.2 
        userData?.setObject(spiderDamageMultiplier, forKey: "spiderDamageMultiplier" as NSCopying)
        
        print("LEVEL TRANSITION")
        print("Player Max Damage: \(playerMaxDamage)")
        print("Player Min Damage: \(playerMinDamage)")
        print("Player Max Health: \(playerMaxHealth)")
        print("Spider Damage Multiplier: \(spiderDamageMultiplier)")
        print("Wavelevel: \(waveLevel)")
        
        switch waveLevel {
            case 1 : nxtLvl = "LevelOne"
            case 2 : nxtLvl = "LevelTwo"
            case 3 : nxtLvl = "LevelThree"
            case 4 : nxtLvl = "LevelOne"
           // case 4 : nxtLvl = "LevelEnd"; goTo(nextLevel: SceneIdentifier(rawValue: nxtLvl)!)
            default:
                print("No Level Found")
        }
        
        buffOne = createBuff()
        buffOne?.size = CGSize(width: 100, height: 160)
        buffOne?.position = CGPoint(x: -80, y: -110)
        buffOne?.zPosition = 3
        addChild(buffOne!)
        
        buffTwo = createBuff()
        buffTwo?.size = CGSize(width: 100, height: 160)
        buffTwo?.position = CGPoint(x: 80, y: -110)
        buffTwo?.zPosition = 3
        
        while buffTwoSpawned == false {
            if buffOne?.name == buffTwo?.name {
                buffTwo?.size = CGSize(width: 100, height: 160)
                buffTwo?.position = CGPoint(x: 80, y: -110)
                buffTwo?.zPosition = 3
                buffTwo = createBuff()
            } else {
                buffTwoSpawned = true
                addChild(buffTwo!)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
        
        if ((node as? SKSpriteNode) != nil) && (node.name?.contains("increaseAttack") == true) {
            print("INCREASE PLAYER'S ATTACK")
            playerMaxDamage = playerMaxDamage * 2
            userData?.setObject(playerMaxDamage, forKey: "playerMaxDamage" as NSCopying)
            playerMinDamage = playerMinDamage * 2
            userData?.setObject(playerMinDamage, forKey: "playerMinDamage" as NSCopying)
            goTo(nextLevel: SceneIdentifier(rawValue: nxtLvl)!)
        } else if ((node as? SKSpriteNode) != nil) && (node.name?.contains("increaseHealth") == true) {
            print("INCREASE PLAYER'S HEALTH")
            playerMaxHealth = playerMaxHealth + 100
            print("Player's new health = \(playerMaxHealth)")
            userData?.setObject(playerMaxHealth, forKey: "playerMaxHealth" as NSCopying)
            goTo(nextLevel: SceneIdentifier(rawValue: nxtLvl)!)
        } else if ((node as? SKSpriteNode) != nil) && (node.name?.contains("restoreHealth") == true) {
            print("RESTORE PLAYER TO FULL HEALTH")
            playerHealth = playerMaxHealth
            goTo(nextLevel: SceneIdentifier(rawValue: nxtLvl)!)
        } else if ((node as? SKSpriteNode) != nil) && (node.name?.contains("pointsMultiplier") == true) {
            print("INCREASE POINT GENERATION")
            points = points * 2
            goTo(nextLevel: SceneIdentifier(rawValue: nxtLvl)!)
        }
        
    }
    
    func createBuff() -> SKSpriteNode {
        
        //creates spiders
        let increaseAttack = Buffs(buffType: .increaseAttack)
        let increaseHealth = Buffs(buffType: .increaseHealth)
        let healToFull = Buffs(buffType: .healToFull)
        let pointsMultiplier = Buffs(buffType: .pointsMultiplier)
        
        //Initialize the properties of each card
        increaseAttack.name = "increaseAttack"
        increaseHealth.name = "increaseHealth"
        healToFull.name = "restoreHealth"
        pointsMultiplier.name = "pointsMultiplier"
        
        
        //Creates an arrary of cards
        let buffs = [increaseAttack, increaseHealth, healToFull, pointsMultiplier]
        
        //picks a spider from the arrary
        let randomBuff = Int(arc4random_uniform(UInt32(buffs.count)))
        
        //returns a spider
        return buffs[randomBuff]
        
    }

}
