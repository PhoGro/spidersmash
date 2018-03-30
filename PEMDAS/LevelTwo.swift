//
//  lvl2.swift
//  PEMDAS
//
//  Created by John Davenport on 2/1/18.
//  Copyright © 2018 John Davenport. All rights reserved.
//

import SpriteKit
import GameplayKit

class LevelTwo: CoreGame {
    
    override init(size: CGSize) {
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        waveLevel = 2
        print("Current Wave: \(waveLevel). It's suposed to be two")
        
        score =  self.userData?.value(forKey: "score") as! Int
        points = score
        
        timeElapsed = self.userData?.value(forKey: "LTV") as! Int
        levelTimerValue = timeElapsed
        
        spidersSmashedCount = self.userData?.value(forKey: "spidersSmashed") as! Int
        
        playerHealth = self.userData?.value(forKey: "playerHealth") as! Double
        
        print("arrived at \(String(describing: nxtLvl))")
        
        //change nxtLvl to "LevelThree"
        nxtLvl = "LevelThree"
        
        
        print("Go to: \(String(describing: nxtLvl))")
        
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

