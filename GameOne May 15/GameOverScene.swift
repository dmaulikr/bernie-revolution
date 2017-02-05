//
//  GameOverScene.swift
//  GameOne
//
//  Created by David Lindsay on 1/10/16.
//  Copyright © 2016 TAPINFUSE, LLC. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    var screenSize: CGSize
    var sb: Scoreboard
    
    init(size: CGSize, score: Int, scoreBoard: Scoreboard) {
        self.screenSize = size
        self.sb = scoreBoard
        super.init(size: size)
        let shapeWidth = size.width - 60.0
        
        backgroundColor = SKColor.whiteColor()
        let gameOver = SKAction.playSoundFileNamed("gameover.wav", waitForCompletion: false)
        self.runAction(gameOver)
        
        let label1 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label1.text = "Game Over"
        label1.fontSize = 40
        label1.fontColor = SKColor.blackColor()
        label1.position = CGPoint(x: size.width/2, y: size.height/2 + 100)
        addChild(label1)
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        let label2 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label2.text = numberFormatter.stringFromNumber(score)
        label2.fontSize = 40
        label2.fontColor = SKColor.blackColor()
        label2.position = CGPoint(x: size.width/2, y: size.height/2 + 55)
        addChild(label2)
        let tenthPlacement = size.height * 0.1
        let button1 = SKShapeNode(rectOfSize: CGSize(width: shapeWidth, height: 60),cornerRadius: 7.0)
        button1.name = "playagain"
        button1.fillColor = SKColor.blueColor()
        button1.position = CGPoint(x: size.width/2, y: size.height - tenthPlacement - 30)
        addChild(button1)
        
        let label3 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label3.text = "Play Again"
        label3.name = "playagain"
        label3.fontSize = 30
        label3.fontColor = SKColor.whiteColor()
        label3.position = CGPoint(x: size.width/2, y:  size.height - tenthPlacement - 40)
        addChild(label3)

        let leaderBoard = SKShapeNode(rectOfSize: CGSize(width: shapeWidth , height: 220),cornerRadius: 7.0)
        leaderBoard.name = "leaderboard"
        leaderBoard.fillColor = SKColor.blueColor()
        leaderBoard.position = CGPoint(x: size.width/2, y: 180)
        addChild(leaderBoard)
        
        let label4 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label4.text = "Leader Board"
        label4.name = "leader"
        label4.fontSize = 25
        label4.fontColor = SKColor.whiteColor()
        label4.position = CGPoint(x: size.width/2, y: 230)
        addChild(label4)

        let defaults = NSUserDefaults.standardUserDefaults()
        var highScore = defaults.integerForKey("First")
        var secondHighestScore = defaults.integerForKey("Second")
        
        if score > secondHighestScore {
            if score > highScore {
                defaults.setInteger(score, forKey: "First")
                defaults.setInteger(highScore, forKey: "Second")
                secondHighestScore = highScore
                highScore = score
            }
            else {
                defaults.setInteger(score, forKey: "Second")
                secondHighestScore = score
            }
        }
        
        let label5 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label5.text = numberFormatter.stringFromNumber(highScore)
        label5.fontSize = 30
        label5.fontColor = SKColor.whiteColor()
        label5.position = CGPoint(x: size.width/2, y: 180)
        addChild(label5)
        
        let label6 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label6.text = numberFormatter.stringFromNumber(secondHighestScore)
        label6.fontSize = 30
        label6.fontColor = SKColor.whiteColor()
        label6.position = CGPoint(x: size.width/2, y: 140)
        addChild(label6)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        
        let node = self.nodeAtPoint(touchLocation)
        
        if node.name == "playagain" {
            print ("play again button pushed")
            sb.resetGameLevel(0)
            print("Game Level = ", sb.gameLevel)
      
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let scene = GameScene(size: self.screenSize)
            self.view?.presentScene(scene, transition:reveal)
        }
    }
}
