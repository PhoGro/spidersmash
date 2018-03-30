//
//  legacyCode.swift
//  PEMDAS
//
//  Created by John Davenport on 3/3/18.
//  Copyright © 2018 John Davenport. All rights reserved.
//

import Foundation


//  var spiderCount = 0 //tracks how many spiders are on the game board

//    //initialize positions for player's HUD positions
//    var posOne = CGPoint(x: -120, y: -250)
//    var posTwo = CGPoint(x: -60, y: -250)
//    var posThree = CGPoint(x: 0, y: -250)
//    var posFour = CGPoint(x: 60, y: -250)
//    var posFive = CGPoint(x: 120, y: -250)
//  var playerHand = [CGPoint]() //used to contain the positions (ABOVE) of the player's hand
//  var playerCard: SKSpriteNode? //designates a player interactable sprite
//  var deck = [SKSpriteNode]() //contains the cards that make up a player's deck of cards
//  var chosenCard = SKSpriteNode() //temp designation for a card being that's been played and needs to e redrawn
//  var newCardPosition: Int? //used for positing cards in and out of player's hand
//   var cardPosition: Int? //generic variable to denote the position of a card being interacted with by a player
//        startingHand()
//  playerLight.shadowColor = SKColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
//  playerLight.ambientColor = SKColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
//        //add shuffle button
//        shuffleButton.name = "shuffleButton"
//        shuffleButton.position = CGPoint(x: 0, y: -310)
//        shuffleButton.physicsBody?.isDynamic = false
//        shuffleButton.zPosition = 2
//        //Set HUD background
//        let playerHUDbackground = SKSpriteNode(imageNamed: "playerHUD2")
//        playerHUDbackground.size = CGSize(width: 340, height: 150)
//        playerHUDbackground.position = CGPoint(x: 0.0, y: -250)
//        playerHUDbackground.zPosition = 0
//       // playerHUD.addChild(playerHUDbackground)
//        func createCard() -> SKSpriteNode {
//
//        //create the five cards for a player's hand.
//        hammerOne = Hammer(hammerType: .purple)
//        hammerTwo = Hammer(hammerType: .orange)
//        hammerThree = Hammer(hammerType: .yellow)
//        hammerFour = Hammer(hammerType: .green)
//        hammerFive = Hammer(hammerType: .blue)
//
//        //Initialize the properties of each card
//        hammerOne?.name = "playerCard"
//        hammerOne?.texture = SKTexture(imageNamed: "Orange")
//
//        hammerTwo?.name = "playerCard"
//        hammerTwo?.texture = SKTexture(imageNamed: "Purple")
//
//        hammerThree?.name = "playerCard"
//        hammerThree?.texture = SKTexture(imageNamed: "Yellow")
//
//        hammerFour?.name = "playerCard"
//        hammerFour?.texture = SKTexture(imageNamed: "Green")
//
//        hammerFive?.name = "playerCard"
//        hammerFive?.texture = SKTexture(imageNamed: "Blue")
//
//        //Creates an arrary of cards
//        deck = [hammerOne!, hammerTwo!, hammerThree!, hammerFour!, hammerFive!]
//
//        //picks a random card from the arrary
//        let randomCardNumber = Int(arc4random_uniform(UInt32(deck.count)))
//
//        //renturs the random card to be used where this function is called.
//        //called in intiial hand setup and when a new card is created to replace a played card
//        return deck[randomCardNumber]
//
//    }

//    func startingHand() {
//
//        //an arrary for the player's card positions
//        playerHand = [posOne, posTwo, posThree, posFour, posFive]
//
//        //Creates a new card for each position in the payer's hand
////        for item in playerHand {
////            playerCard = createCard()
////            playerCard?.position = item
////            playerCard?.size = player.size
////            playerCard?.zPosition = 2
////            playerHUD.addChild(playerCard!)
////        }
//    }

//    func shuffleButtonPressed() {
//
//        playerHUD.enumerateChildNodes(withName: "playerCard", using: {
//            node, stop in
//            node.removeFromParent()
//        })
//
//        //Creates a new card for each position in the payer's hand
//        for item in playerHand {
//            playerCard = createCard()
//            playerCard?.position = item
//            playerCard?.zPosition = 2
//            playerCard?.size = player.size
//            playerHUD.addChild(playerCard!)
//        }
//    }


//        if (firstBody.node?.name?.contains("Spider"))! && (secondBody.node?.name?.contains("hero"))! {
//
//            //combat has started - how do we handle this interaction?
//
//            //Spider is the firstbody and player is secondBody
//
//            let spider = firstBody.node as! SKSpriteNode
//            let player = secondBody.node as! SKSpriteNode
//            var cardName = "default"
//            cardName = playerColor
//            print("CardName: \(cardName)")
//
//            combatStarts(spider: spider, player: player, color: cardName)
//
//        } else if (firstBody.node?.name?.contains("lvlExit"))! && (secondBody.node?.name?.contains("hero"))!  {
//            if lvlExitOpen == false {
//                print("Kill more spiders")
//            } else if lvlExitOpen == true {
//                print("Advance to next level")
//                if nxtLvl != "GameOver" {
//                    goTo(nextLevel: SceneIdentifier(rawValue: nxtLvl)!)
//                } else if nxtLvl == "GameOver" {
//                    gameOver()
//                }
//
//            }
//        } else if (firstBody.node?.name?.contains("heart"))! && (secondBody.node?.name?.contains("hero"))!  {
//
//                let heartAnimation = SKEmitterNode(fileNamed: "heart")
//                heartAnimation?.position = (firstBody.node!.position)
//                self.addChild((heartAnimation)!)
//                heartAnimation?.run(SKAction.wait(forDuration: 0.3), completion: {heartAnimation?.removeFromParent()})
//                gainLife()
//                firstBody.node?.removeFromParent()
//
//        } else if (firstBody.node?.name?.contains("projectile"))! && (secondBody.node?.name?.contains("hero"))! {
//                print("Projectile Hit")
//                firstBody.node?.removeFromParent()
//        } else if (firstBody.node?.name?.contains("projectile"))! && (secondBody.node?.name?.contains("Wall"))! {
//                print("wall hit")
//                firstBody.node?.removeFromParent()
//        }
//    }
//}



