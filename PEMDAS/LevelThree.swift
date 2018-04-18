//
//  lvl2.swift
//  PEMDAS
//
//  Created by John Davenport on 2/1/18.
//  Copyright © 2018 John Davenport. All rights reserved.
//

import SpriteKit
import GameplayKit

class LevelThree: CoreGame {
    
    override init(size: CGSize) {
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
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

        print("LEVEL THREE")
        print("Player Max Damage: \(playerMaxDamage)")
        print("Player Min Damage: \(playerMinDamage)")
        print("Player Max Health: \(playerMaxHealth)")
        print("Spider Damage Multiplier: \(spiderDamageMultiplier)")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        
    }
    
    
    
}

