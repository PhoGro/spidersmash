//
//  HeathBar.swift
//  PEMDAS
//
//  Created by John Davenport on 12/27/17.
//  Copyright © 2017 John Davenport. All rights reserved.
//

import Foundation
import SpriteKit

class HealthBar:SKNode {
    var background:SKSpriteNode?
    var bar:SKSpriteNode?
    var _progress:CGFloat = 0
    var progress:CGFloat {
        get {
            return _progress
        }
        set {
            let value = max(min(newValue,1.0),0.0)
            if let bar = bar {
                bar.yScale = value
                _progress = value
            }
        }
    }
    
    convenience init(color:SKColor, size:CGSize) {
        self.init()
        background = SKSpriteNode(color:SKColor.white,size:size)
        bar = SKSpriteNode(color:color,size:size)
        if let bar = bar, let background = background {
            bar.yScale = 0.0
            bar.zPosition = 1.0
            bar.position = CGPoint(x:-size.width/2,y:0)
            bar.anchorPoint = CGPoint(x:0.0,y:0.5)
            addChild(background)
            addChild(bar)
        }
    }
}
