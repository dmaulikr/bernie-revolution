//
//  CreditsScene.swift
//  GameOne
//
//  Created by David Lindsay
//  Copyright © 2016 David Lindsay All rights reserved.
//

import Foundation
import SpriteKit

class CreditsScene: SKScene {
 
    var screenSize: CGSize
    
    var lastScene: SKScene
    
    init(size: CGSize, scene: SKScene) {
        self.screenSize = size
        self.lastScene = scene

        super.init(size: size)
        let tenthPlacement = size.height * 0.1
        let shapeWidth = size.width - 60.0
        
        let creditsBoard = SKShapeNode(rectOf: CGSize(width: shapeWidth , height: size.height * 0.75),cornerRadius: 7.0)
        creditsBoard.name = "creditsBoard"
        creditsBoard.fillColor = SKColor.blue
        creditsBoard.position = CGPoint(x: size.width/2, y: size.height - ((size.height * 0.75)/2) - 20)
        addChild(creditsBoard)
        
        let label1 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label1.text = "Credits"
        label1.name = "creditsLabel"
        label1.fontSize = 30
        label1.fontColor = SKColor.white
        label1.position = CGPoint(x: size.width/2, y: size.height - tenthPlacement)
        addChild(label1)
        
        let backButton = SKShapeNode(rectOf: CGSize(width: shapeWidth , height: 80),cornerRadius: 7.0)
        backButton.name = "back"
        backButton.fillColor = SKColor.blue
        backButton.position = CGPoint(x: size.width/2, y: 60)
        addChild(backButton)
        
        let label2 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label2.text = "Back"
        label2.name = "back"
        label2.fontSize = 30
        label2.fontColor = SKColor.white
        label2.position = CGPoint(x: size.width/2, y: 50)
        addChild(label2)
        
        let label3 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label3.text = "Software Development:"
        label3.fontSize = 14
        label3.fontColor = SKColor.white
        label3.horizontalAlignmentMode = .left
        label3.position = CGPoint(x: 40, y: size.height - tenthPlacement - 35)
        addChild(label3)
        
        let label35 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label35.text = "David Lindsay"
        label35.fontSize = 14
        label35.fontColor = SKColor.white
        label35.horizontalAlignmentMode = .left
        label35.position = CGPoint(x: 40, y: size.height - tenthPlacement - 50)
        addChild(label35)
        
        let label4 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label4.text = "Bernie hair graphic: Andrew Hart"
        label4.fontSize = 12
        label4.fontColor = SKColor.white
        label4.horizontalAlignmentMode = .left
        label4.position = CGPoint(x: 40, y: size.height - tenthPlacement - 75)
        addChild(label4)
        
        let label5 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label5.text = "Anger emoticon, happy emoticon"
        label5.fontSize = 12
        label5.fontColor = SKColor.white
        label5.horizontalAlignmentMode = .left
        label5.position = CGPoint(x: 40, y: size.height - tenthPlacement - 90)
        addChild(label5)
        
        let label6 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label6.text = "made by Freepik from"
        label6.fontSize = 12
        label6.fontColor = SKColor.white
        label6.horizontalAlignmentMode = .left
        label6.position = CGPoint(x: 40, y: size.height - tenthPlacement - 105)
        addChild(label6)
        
        let label65 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label65.text = "www.flaticon.com"
        label65.fontSize = 12
        label65.fontColor = SKColor.white
        label65.horizontalAlignmentMode = .left
        label65.position = CGPoint(x: 40, y: size.height - tenthPlacement - 120)
        addChild(label65)
        
        let label7 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label7.text = "Graphics designed by Freepik:"
        label7.fontSize = 12
        label7.fontColor = SKColor.white
        label7.horizontalAlignmentMode = .left
        label7.position = CGPoint(x: 40, y: size.height - tenthPlacement - 135)
        addChild(label7)
        
        let label8 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label8.text = "cherries, bank, TV and coins"
        label8.fontSize = 12
        label8.fontColor = SKColor.white
        label8.horizontalAlignmentMode = .left
        label8.position = CGPoint(x: 40, y: size.height - tenthPlacement - 150)
        addChild(label8)
        
        let label10 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label10.text = "Bomb from opengameart.com"
        label10.fontSize = 12
        label10.fontColor = SKColor.white
        label10.horizontalAlignmentMode = .left
        label10.position = CGPoint(x: 40, y: size.height - tenthPlacement - 165)
        addChild(label10)
        
        let label15 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label15.text = "Audio sounds from soundbible.com:"
        label15.fontSize = 12
        label15.fontColor = SKColor.white
        label15.horizontalAlignmentMode = .left
        label15.position = CGPoint(x: 40, y: size.height - tenthPlacement - 180)
        addChild(label15)
        
        let label11 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label11.text = "Gun Shot audio by Marvin"
        label11.fontSize = 12
        label11.fontColor = SKColor.white
        label11.horizontalAlignmentMode = .left
        label11.position = CGPoint(x: 40, y: size.height - tenthPlacement - 195)
        addChild(label11)
        
        let label12 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label12.text = "Explosion audio by Mark DiAngelo"
        label12.fontSize = 12
        label12.fontColor = SKColor.white
        label12.horizontalAlignmentMode = .left
        label12.position = CGPoint(x: 40, y: size.height - tenthPlacement - 210)
        addChild(label12)
        
        let label13 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label13.text = "Game Over audio by fins"
        label13.fontSize = 12
        label13.fontColor = SKColor.white
        label13.horizontalAlignmentMode = .left
        label13.position = CGPoint(x: 40, y: size.height - tenthPlacement - 225)
        addChild(label13)
        
        let label14 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label14.text = "Success audio by fins"
        label14.fontSize = 12
        label14.fontColor = SKColor.white
        label14.horizontalAlignmentMode = .left
        label14.position = CGPoint(x: 40, y: size.height - tenthPlacement - 240)
        addChild(label14)
        
        let label16 = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        label16.text = "Not affiliated with Bernie 2016."
        label16.fontSize = 12
        label16.fontColor = SKColor.white
        label16.horizontalAlignmentMode = .left
        label16.position = CGPoint(x: 40, y: size.height - tenthPlacement - 265)
        addChild(label16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let node = self.atPoint(touchLocation)
        
        if node.name == "back" {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let scene = self.lastScene
            self.view?.presentScene(scene, transition:reveal)
        }
    }
}
