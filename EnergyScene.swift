//
//  EnergyScene.swift
//
//
//  Created by David Lindsay
//  Copyright © 2016 David Lindsay All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion

class EnergyScene: SKScene, SKPhysicsContactDelegate {
    let ballName = "redBall"
    var gravityDirection = CGVector(dx: 0,dy: -9.8)
    
    let motionManager = CMMotionManager()
    let motion = CMDeviceMotion()
    
    var xaccel: Float
    var xvelocity: Float
    var yaccel: Float
    var yvelocity: Float
    var childNodes: Int
    
    var mostRecentAngle: Float
    
    var screenSize: CGSize
    var sb: Scoreboard
    
    var player = SKSpriteNode()
    var mainScene: SKScene
    var successSound: SKAction
    
    init(size: CGSize, score: Int, scoreBoard: Scoreboard, scene: SKScene) {
        self.screenSize = size
        self.sb = scoreBoard
        self.xaccel = 0.0
        self.yaccel = 0.0
        self.xvelocity = 0.0
        self.yvelocity = 0.0
        self.mostRecentAngle = 0.0
        self.childNodes = 0
        self.mainScene = scene
        self.successSound = SKAction.playSoundFileNamed("success.wav", waitForCompletion: false)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func addBernie() -> SKSpriteNode{

        let player = SKSpriteNode(imageNamed: "bernie")
    
        player.position = CGPoint(x:size.width/2, y: size.height)
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: 40.0)
        player.physicsBody!.isDynamic = true
        player.physicsBody!.mass = 0.7
        player.physicsBody!.friction = 0.0
        player.physicsBody!.restitution = 0.0
        player.physicsBody?.categoryBitMask = PhysicsCategory.MainActor
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Coins
        player.physicsBody?.collisionBitMask = PhysicsCategory.All // & PhysicsCategory.Coins
        player.physicsBody!.affectedByGravity = true
        
        self.addChild(player)
        return(player)
    }
    
    func addCoins(_ point: CGPoint) {
        let coins = SKSpriteNode(imageNamed: "coins160")
        coins.position = point
        coins.physicsBody = SKPhysicsBody(circleOfRadius: 30.0)
        coins.physicsBody!.isDynamic = false
        coins.physicsBody!.mass = 0.1
        coins.physicsBody!.friction = 0.0
        coins.physicsBody!.restitution = 0.1
        coins.physicsBody!.affectedByGravity = true
        coins.physicsBody?.categoryBitMask = PhysicsCategory.Coins
        coins.physicsBody?.contactTestBitMask = PhysicsCategory.MainActor
        coins.physicsBody?.collisionBitMask = PhysicsCategory.None
        coins.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(coins)
    }
    
    func addSprite(_ point: CGPoint) {
        let sprite = SKSpriteNode(imageNamed: "redtv")
        sprite.position = point
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: 45.0)
        sprite.physicsBody!.isDynamic = true
        sprite.physicsBody!.mass = 0.8
        sprite.physicsBody!.friction = 0.0
        sprite.physicsBody!.restitution = 0.1
        sprite.physicsBody!.affectedByGravity = false
        
        self.addChild(sprite)
    }
    
    func addButton(_ point:CGPoint) {
        let sprite = SKShapeNode(circleOfRadius: 45.0)
        sprite.position = point
        sprite.fillColor = UIColor.red
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: 45.0)
        sprite.physicsBody!.isDynamic = false
        sprite.physicsBody!.mass = 0.8
        sprite.physicsBody!.friction = 0.0
        sprite.physicsBody!.restitution = 0.1
        sprite.physicsBody!.affectedByGravity = false
        self.addChild(sprite)
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = backColor
        physicsBody = SKPhysicsBody(edgeLoopFrom: view.frame)
        self.physicsWorld.gravity = gravityDirection
        self.physicsWorld.contactDelegate = self
        
        self.addChild(self.sb)
        
        motionManager.startDeviceMotionUpdates()
        player = addBernie()
        let spacer = size.width / 7.0
        for index in 0...6 {
            addCoins(CGPoint(x:25.0 + (CGFloat(index) * (spacer)), y: CGFloat(40)))
        }
        
        // add TVs
        addSprite(CGPoint(x: size.width/2 - 50.0, y: size.height/2 + 10.0))
        addSprite(CGPoint(x: size.width/2 - 50.0, y: size.height/2 + 40.0))
        addSprite(CGPoint(x: size.width/2, y: size.height/2 + 10.0))
        addSprite(CGPoint(x: size.width/2, y: size.height/2 + 40.0))
        addSprite(CGPoint(x: size.width/2 + 50.0, y: size.height/2 + 10.0))
        addSprite(CGPoint(x: size.width/2 + 50.0, y: size.height/2 + 40.0))
        self.childNodes = self.children.count
    }
    
    override func update(_ currentTime: TimeInterval) {

        if let data = motionManager.deviceMotion {
            let gravity = data.gravity
            self.physicsWorld.gravity.dx = CGFloat(gravity.x)
            self.physicsWorld.gravity.dy = CGFloat(gravity.y)
        }
        
        if sb.remainingTime <= 0 {
            self.removeAllChildren()
            self.removeAllActions()
            let reveal = SKTransition.flipHorizontal(withDuration: 0.2)
            self.mainScene.removeAllChildren()
            motionManager.stopDeviceMotionUpdates()
            self.view?.presentScene(self.mainScene, transition:reveal)
        }
    }
    
    //
    //    didBeginContact
    //
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody?
        var secondBody: SKPhysicsBody?

        if contact.bodyA.categoryBitMask == contact.bodyB.categoryBitMask {
            return
        }
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if (firstBody!.categoryBitMask == PhysicsCategory.MainActor) && (secondBody!.categoryBitMask == PhysicsCategory.Coins) ||
            (firstBody!.categoryBitMask == PhysicsCategory.Coins) && (secondBody!.categoryBitMask == PhysicsCategory.MainActor) {
            if let firstNode = firstBody?.node, let secondNode = secondBody?.node {
                playerDidCollideWithTarget(firstNode, second:secondNode)
            }
            else {
            }
        }
    }
    
    //
    //  projectileDidCollideWithTarget
    //
    
    func playerDidCollideWithTarget(_ first:SKNode, second:SKNode) {

        let firstSprite = first as! SKSpriteNode
        let secondSprite = second as! SKSpriteNode
        let action = SKAction.colorize(with: UIColor.yellow, colorBlendFactor: 1.0, duration: 1.0)
        firstSprite.run(action)
        self.run(self.successSound)
        secondSprite.removeFromParent()
        if self.children.count == (self.childNodes - 7) {
            self.removeAllChildren()
            self.removeAllActions()
            let reveal = SKTransition.flipHorizontal(withDuration: 0.2)
            self.mainScene.removeAllChildren()
            motionManager.stopDeviceMotionUpdates()
            self.view?.presentScene(self.mainScene, transition:reveal)
        }
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
    }
}
