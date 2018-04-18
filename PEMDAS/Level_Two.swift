//
//  Level_Two.swift
//  PEMDAS
//
//  Created by John Davenport on 1/20/18.
//  Copyright © 2018 John Davenport. All rights reserved.
//

import SpriteKit
import GameplayKit

class LevelTwo: GameScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        //change nxtLvl to "LevelOne"
        nxtLvl = "GameScene"
        
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
