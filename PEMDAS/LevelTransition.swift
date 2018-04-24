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
    let removeAnimation = SKEmitterNode(fileNamed: "RemoveCard")
    let removeCardSequence = SKAction()
    let wait = SKAction.wait(forDuration: 1.0)
    let moveToCenter = SKAction.move(to: CGPoint(x: 0.5, y: 0.5), duration: 0.5)
    let scaleToTwoTimes = SKAction.scale(by: 2, duration: 0.5)
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
        
        playerMaxDamage = self.userData?.value(forKey: "playerMaxDamage") as! Double
        
        playerMaxDamage = playerMaxDamage + (playerMaxDamage * 0.2)
        userData?.setObject(playerMaxDamage, forKey: "playerMaxDamage" as NSCopying)
        
        playerMinDamage = playerMinDamage + (playerMinDamage * 0.2)
        userData?.setObject(playerMinDamage, forKey: "playerMinDamage" as NSCopying)
        
        spiderDamageMultiplier = self.userData?.value(forKey: "spiderDamageMultiplier") as! Double

        spiderDamageMultiplier = spiderDamageMultiplier + (spiderDamageMultiplier * 0.2)
        userData?.setObject(spiderDamageMultiplier, forKey: "spiderDamageMultiplier" as NSCopying)
        
        spiderHealthMultiplier = self.userData?.value(forKey: "spiderHealthMultiplier") as! Double
        
        spiderHealthMultiplier = spiderHealthMultiplier + (spiderHealthMultiplier * 0.35)
        userData?.setObject(spiderHealthMultiplier, forKey: "spiderHealthMultiplier" as NSCopying)
        
        print("LEVEL TRANSITION")
        print("Player Max Damage: \(playerMaxDamage)")
        print("Player Min Damage: \(playerMinDamage)")
        print("Player Max Health: \(playerMaxHealth)")
        print("Spider Damage Multiplier: \(spiderDamageMultiplier)")
        print("Spider Health Multiplier: \(spiderHealthMultiplier)")
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
        
        while buffTwoSpawned == false {
            if buffOne?.name == buffTwo?.name {
                print("recreate buff two")
                buffTwo = createBuff()
            } else {
                buffTwo?.size = CGSize(width: 100, height: 160)
                buffTwo?.position = CGPoint(x: 80, y: -110)
                buffTwo?.zPosition = 3
                buffTwoSpawned = true
                addChild(buffTwo!)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
        
        if node == buffOne {
            
            //let selectedBuff = buffOne?.texture
            
            switch buffOne?.name {
                
            case "increaseAttack" :
                print("INCREASE PLAYER'S ATTACK")
                playerMaxDamage = playerMaxDamage + (playerMaxDamage * 0.5)
                userData?.setObject(playerMaxDamage, forKey: "playerMaxDamage" as NSCopying)
                playerMinDamage = playerMinDamage + (playerMinDamage * 0.5)
                userData?.setObject(playerMinDamage, forKey: "playerMinDamage" as NSCopying)
                
                removeAnimation?.position = (buffTwo?.position)!
                addChild(removeAnimation!)
                buffTwo?.removeFromParent()
                
                removeAnimation?.run(wait, completion: {
                    self.removeFromParent()
                    self.goTo(nextLevel: SceneIdentifier(rawValue: self.nxtLvl)!)
                })

            case "increaseHealth" :
                print("INCREASE PLAYER'S HEALTH")
                playerMaxHealth = playerMaxHealth + 100
                print("Player's new health = \(playerMaxHealth)")
                userData?.setObject(playerMaxHealth, forKey: "playerMaxHealth" as NSCopying)
                removeAnimation?.position = (buffTwo?.position)!
                addChild(removeAnimation!)
                buffTwo?.removeFromParent()
            
                removeAnimation?.run(wait, completion: {
                    self.removeFromParent()
                    self.goTo(nextLevel: SceneIdentifier(rawValue: self.nxtLvl)!)
                })
            
            case "restoreHealth" :
                print("RESTORE PLAYER'S HEALTH")
                playerHealth = playerMaxHealth
                
                removeAnimation?.position = (buffTwo?.position)!
                addChild(removeAnimation!)
                buffTwo?.removeFromParent()
            
                removeAnimation?.run(wait, completion: {
                    self.removeFromParent()
                    self.goTo(nextLevel: SceneIdentifier(rawValue: self.nxtLvl)!)
                })
            
            case "pointsMultiplier" :
                print("INCREASE POINT GENERATION")
                points = points * 2
                removeAnimation?.position = (buffTwo?.position)!
                addChild(removeAnimation!)
                buffTwo?.removeFromParent()
            
                removeAnimation?.run(wait, completion: {
                    self.removeFromParent()
                    self.goTo(nextLevel: SceneIdentifier(rawValue: self.nxtLvl)!)
                })
            
            default : print("default")
            }
            
        } else if node == buffTwo {
            
            switch buffTwo?.name {
            
            case "increaseAttack" :
                print("INCREASE PLAYER'S ATTACK")
                playerMaxDamage = playerMaxDamage + (playerMaxDamage * (50/100))
                userData?.setObject(playerMaxDamage, forKey: "playerMaxDamage" as NSCopying)
                playerMinDamage = playerMinDamage + (playerMinDamage * (50/100))
                userData?.setObject(playerMinDamage, forKey: "playerMinDamage" as NSCopying)
                
                removeAnimation?.position = (buffOne?.position)!
                addChild(removeAnimation!)
                buffOne?.removeFromParent()
                
                removeAnimation?.run(wait, completion: {
                    self.removeFromParent()
                    self.goTo(nextLevel: SceneIdentifier(rawValue: self.nxtLvl)!)
                })
                
            case "increaseHealth" :
                print("INCREASE PLAYER'S HEALTH")
                playerMaxHealth = playerMaxHealth + 100
                print("Player's new health = \(playerMaxHealth)")
                userData?.setObject(playerMaxHealth, forKey: "playerMaxHealth" as NSCopying)
                removeAnimation?.position = (buffOne?.position)!
                addChild(removeAnimation!)
                buffOne?.removeFromParent()
            
                removeAnimation?.run(wait, completion: {
                    self.removeFromParent()
                    self.goTo(nextLevel: SceneIdentifier(rawValue: self.nxtLvl)!)
                })
                
            case "restoreHealth" :
                print("RESTORE PLAYER'S HEALTH")
                playerHealth = playerMaxHealth
                removeAnimation?.position = (buffOne?.position)!
                addChild(removeAnimation!)
                buffOne?.removeFromParent()
            
                removeAnimation?.run(wait, completion: {
                    self.removeFromParent()
                    self.goTo(nextLevel: SceneIdentifier(rawValue: self.nxtLvl)!)
                })
                
            case "pointsMultiplier" :
                print("INCREASE POINT GENERATION")
                points = points * 2
                removeAnimation?.position = (buffOne?.position)!
                addChild(removeAnimation!)
                buffOne?.removeFromParent()
            
                removeAnimation?.run(wait, completion: {
                    self.removeFromParent()
                    self.goTo(nextLevel: SceneIdentifier(rawValue: self.nxtLvl)!)
                })
                
            default : print("default")
            }
        }
        
//        if ((node as? SKSpriteNode) != nil) && (node.name?.contains("increaseAttack") == true) {
//            print("INCREASE PLAYER'S ATTACK")
//            playerMaxDamage = playerMaxDamage + (playerMaxDamage * (50/100))
//            userData?.setObject(playerMaxDamage, forKey: "playerMaxDamage" as NSCopying)
//            playerMinDamage = playerMinDamage + (playerMinDamage * (50/100))
//            userData?.setObject(playerMinDamage, forKey: "playerMinDamage" as NSCopying)
//            goTo(nextLevel: SceneIdentifier(rawValue: nxtLvl)!)
//        } else if ((node as? SKSpriteNode) != nil) && (node.name?.contains("increaseHealth") == true) {
//            print("INCREASE PLAYER'S HEALTH")
//            playerMaxHealth = playerMaxHealth + 100
//            print("Player's new health = \(playerMaxHealth)")
//            userData?.setObject(playerMaxHealth, forKey: "playerMaxHealth" as NSCopying)
//            goTo(nextLevel: SceneIdentifier(rawValue: nxtLvl)!)
//        } else if ((node as? SKSpriteNode) != nil) && (node.name?.contains("restoreHealth") == true) {
//            print("RESTORE PLAYER TO FULL HEALTH")
//            playerHealth = playerMaxHealth
//            goTo(nextLevel: SceneIdentifier(rawValue: nxtLvl)!)
//        } else if ((node as? SKSpriteNode) != nil) && (node.name?.contains("pointsMultiplier") == true) {
//            print("INCREASE POINT GENERATION")
//            points = points * 2
//            goTo(nextLevel: SceneIdentifier(rawValue: nxtLvl)!)
//        }
        
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
