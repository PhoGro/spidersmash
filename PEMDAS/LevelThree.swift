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
        
        waveLevel = 3
        print("Current Wave: \(waveLevel). It's suposed to be three")
        
        score =  self.userData?.value(forKey: "score") as! Int
        points = score
        
        timeElapsed = self.userData?.value(forKey: "LTV") as! Int
        levelTimerValue = timeElapsed
        
        playerHealth = self.userData?.value(forKey: "playerHealth") as! Double
        
        spidersSmashedCount = self.userData?.value(forKey: "spidersSmashed") as! Int
        
        print("arrived at \(String(describing: nxtLvl))")
        
        //change nxtLvl to "LevelOne"
        nxtLvl = "LevelEnd"
        print("Go to: \(String(describing: nxtLvl))")
        //to goal
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        print("touch!")
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

