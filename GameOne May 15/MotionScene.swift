//
//  MotionScene.swift
//  GameOne
//
//  Created by David Lindsay on 4/30/16.
//  Copyright © 2016 TAPINFUSE, LLC. All rights reserved.
//
import UIKit
//import Foundation
import QuartzCore
import SceneKit
import SpriteKit
import CoreMotion
//import UIKit
func SIGN (x: Float) -> Float {
    if (x < 0) {
        return -1.0
    }
    else {
        return 1.0
    }
}

class MotionScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "bernie")
    var newScene: SKScene?
    let motionManager = CMMotionManager()
    
    var xaccel: Float
    var xvelocity: Float
    var yaccel: Float
    var yvelocity: Float
    
    var mostRecentAngle: Float
    
    //butterfly: UIImageView
    
    var screenSize: CGSize
    var sb: Scoreboard
    
    var timer = NSTimer()
    
    init(size: CGSize, won:Bool, score: Int, scoreBoard: Scoreboard) {
        self.screenSize = size
        self.sb = scoreBoard
        self.xaccel = 0.0
        self.yaccel = 0.0
        self.xvelocity = 0.0
        self.yvelocity = 0.0
        self.mostRecentAngle = 0.0
        super.init(size: size)
               
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = backColor
        physicsBody = SKPhysicsBody(edgeLoopFromRect: view.frame)
 
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        player.zPosition = 0
        
        player.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: CGFloat(TargetBernieSize),height: CGFloat(TargetBernieSize)) )
        player.physicsBody?.dynamic = true
        
        // categoryBitMask defines what logical 'categories' this body belongs to
        
        player.physicsBody?.categoryBitMask = PhysicsCategory.MainActor
        
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Bomb //Defines what logical 'categories' of bodies this body generates intersection notifications with.
        
        player.physicsBody?.collisionBitMask = PhysicsCategory.None
        player.physicsBody = SKPhysicsBody(circleOfRadius: 40.0)
        player.physicsBody!.dynamic = true
        player.physicsBody!.mass = 0.7
        player.physicsBody!.friction = 0.0
        player.physicsBody!.restitution = 0.1
        player.physicsBody!.affectedByGravity = true
        
        addChild(player)
        
//        if motionManager.gyroAvailable {
//            motionManager.gyroUpdateInterval = 0.1
//            motionManager.startGyroUpdates()
//        }

        if motionManager.deviceMotionAvailable {
            motionManager.startAccelerometerUpdates()
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) {
                //[weak self] (data: CMDeviceMotion?, error: NSError?) in
                [weak self] (data, error) in
                
                self!.scene!.physicsWorld.gravity = CGVectorMake(CGFloat((data?.acceleration.x)!) * 3, CGFloat((data?.acceleration.y)!) * 3)

            }
        }
        
        let aSelector : Selector = #selector(MotionScene.tick)
        timer = NSTimer.scheduledTimerWithTimeInterval(0.03, target: self, selector: aSelector, userInfo: nil, repeats: true)
        
        //        audioNode.autoplayLooped = false
        //        audioNode.positional = true
        //        addChild(audioNode)
        
        //physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
//        gameScoreboard.name = "Scoreboard"
//        gameScoreboard.zPosition = 100
//        gameScoreboard.position = CGPointMake(size.width/2, size.height/2)
//        gameScoreboard.startTimer(20.0)
//        
//        addChild(gameScoreboard)
//        
//        gameScoreboard.layoutForScene()
//        gameScoreboard.startScoreBoard()
//        gameScoreboard.resetGameLevel(1)
//        print("Game Level didMoveToView = ", gameScoreboard.gameLevel)
        
        pointsPerHit = initPointsPerHit
        pointsPerBankHit = initPointsPerBankHit
        
        newScene = GameScene(size: scene!.size)
        newScene!.scaleMode = .AspectFill
        
//        runAction(SKAction.repeatActionForever(
//            SKAction.sequence([
//                SKAction.runBlock(addTarget),                   // add target
//                SKAction.runBlock(runScoreBoard),
//                SKAction.waitForDuration(0.75)                  // was 1.0
//                ])
//            ))
    }

    func tick () {
        //butterfly.transform = CGAffineTransformIdentity
        //let vector = CGVector(dx: <#T##Double#>, dy: <#T##Double#>)
        //player.runAction(SKAction.moveBy(<#T##delta: CGVector##CGVector#>, duration: <#T##NSTimeInterval#>))
    }




}