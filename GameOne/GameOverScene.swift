//
//  GameOverScene.swift
//
//  Created by David Lindsay
//  Copyright © 2016 David Lindsay All rights reserved.
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
        let tenthPlacement = size.height * 0.1
        
        backgroundColor = SKColor.white
        let gameOver = SKAction.playSoundFileNamed("gameover.wav", waitForCompletion: false)
        self.run(gameOver)
        
        let label1 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label1.text = "Game Over"
        label1.fontSize = 40
        label1.fontColor = SKColor.black
        label1.position = CGPoint(x: size.width/2, y: size.height/2 + 90)
        addChild(label1)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        let label2 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label2.text = numberFormatter.string(from: NSNumber(value: score))
        label2.fontSize = 40
        label2.fontColor = SKColor.black
        label2.position = CGPoint(x: size.width/2, y: size.height/2 + 50)
        addChild(label2)
   
        let button1 = SKShapeNode(rectOf: CGSize(width: shapeWidth, height: 60),cornerRadius: 7.0)
        button1.name = "playagain"
        button1.fillColor = SKColor.blue
        button1.position = CGPoint(x: size.width/2, y: size.height - tenthPlacement - 30)
        addChild(button1)
        
        let label3 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label3.text = "Play Again"
        label3.name = "playagain"
        label3.fontSize = 30
        label3.fontColor = SKColor.white
        label3.position = CGPoint(x: size.width/2, y:  size.height - tenthPlacement - 40)
        addChild(label3)

        let leaderBoard = SKShapeNode(rectOf: CGSize(width: shapeWidth , height: 130),cornerRadius: 7.0)
        leaderBoard.name = "leaderboard"
        leaderBoard.fillColor = SKColor.blue
        leaderBoard.position = CGPoint(x: size.width/2, y: tenthPlacement + 130)
        addChild(leaderBoard)
        
        let label4 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label4.text = "Leader Board"
        label4.name = "leader"
        label4.fontSize = 26
        label4.fontColor = SKColor.white
        label4.position = CGPoint(x: size.width/2, y: tenthPlacement + 152)
        addChild(label4)
        
        let defaults = UserDefaults.standard
        var highScore = defaults.integer(forKey: "First")
        var secondHighestScore = defaults.integer(forKey: "Second")
        
        if score > secondHighestScore {
            if score > highScore {
                defaults.set(score, forKey: "First")
                defaults.set(highScore, forKey: "Second")
                secondHighestScore = highScore
                highScore = score
            }
            else {
                defaults.set(score, forKey: "Second")
                secondHighestScore = score
            }
        }
        
        let label5 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label5.text = numberFormatter.string(from: NSNumber(value: highScore))
        label5.fontSize = 25
        label5.fontColor = SKColor.white
        label5.position = CGPoint(x: size.width/2, y: tenthPlacement + 120)
        addChild(label5)
        
        let label6 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label6.text = numberFormatter.string(from: NSNumber(value: secondHighestScore))
        label6.fontSize = 25
        label6.fontColor = SKColor.white
        label6.position = CGPoint(x: size.width/2, y: tenthPlacement + 95)
        addChild(label6)
        
        let creditsButton = SKShapeNode(rectOf: CGSize(width: 90 , height: 44),cornerRadius: 7.0)
        creditsButton.name = "credits"
        creditsButton.fillColor = SKColor.blue
        creditsButton.position = CGPoint(x: size.width/2, y: tenthPlacement + 27)
        addChild(creditsButton)
        
        let label7 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label7.text = "Credits"
        label7.name = "credits"
        label7.fontSize = 16
        label7.fontColor = SKColor.white
        label7.position = CGPoint(x: size.width/2, y: tenthPlacement + 22)
        addChild(label7)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let node = self.atPoint(touchLocation)
        
        if node.name == "playagain" {
            sb.resetGameLevel(0)
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let scene = GameScene(size: self.screenSize)
            self.view?.presentScene(scene, transition:reveal)
        }
        
        if node.name == "credits" {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let scene = CreditsScene(size: self.screenSize, scene: self)
            self.view?.presentScene(scene, transition:reveal)
        }
    }
}
