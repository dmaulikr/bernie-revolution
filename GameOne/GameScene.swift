//
//  GameScene.swift
//
//  Created by David Lindsay
//  Copyright © 2016 David Lindsay All rights reserved.
//
import Foundation
import AVFoundation
import SpriteKit

struct PhysicsCategory {
    static let None         : UInt32 = 0
    static let All          : UInt32 = UInt32.max
    static let Target       : UInt32 = 0b001
    static let MainActor    : UInt32 = 0b010
    static let Projectile   : UInt32 = 0b011
    static let Bomb         : UInt32 = 0b100
    static let Bank         : UInt32 = 0b101
    static let Coins        : UInt32 = 0b110
}

//
// Vector math functions from an online tutorial
//
 
func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "bernie180clear")
    
    var Target1sDestroyed = 0
    let gameScoreboard = Scoreboard()
    var fireEmitter: SKEmitterNode?
    var newScene: SKScene?
    
    var startTime = TimeInterval()
    var gameTime:Double = 10
    
    let gunshot = SKAction.playSoundFileNamed("gunshot.wav", waitForCompletion: false)
    let explosion = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
  
        backgroundColor = backColor
 
        player.position = CGPoint(x: size.width/2, y: 45.0 + player.size.height/2.0)
        player.size = CGSize(width: 90, height: 90)
        
        player.zPosition = 0
        player.physicsBody = SKPhysicsBody(circleOfRadius: (player.size.height * 0.33))

        player.physicsBody?.isDynamic = true
        
        player.physicsBody?.categoryBitMask = PhysicsCategory.MainActor        
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Bomb
        player.physicsBody?.collisionBitMask = PhysicsCategory.None
   
        addChild(player)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameScoreboard.name = "Scoreboard"
        gameScoreboard.zPosition = 100
        gameScoreboard.position = CGPoint(x: size.width/2, y: size.height/2)
        
        addChild(gameScoreboard)
        
        gameScoreboard.layoutForScene()
        gameScoreboard.startScoreBoard()
        
        pointsPerHit = initPointsPerHit
        pointsPerBankHit = initPointsPerBankHit
        
        if newScene == nil {
            gameScoreboard.startTimer(20.0)
            gameScoreboard.resetGameLevel(1)
        }
        
        newScene = GameScene(size: scene!.size)
        newScene!.scaleMode = .aspectFill
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addTarget),                   // add target
                SKAction.run(runScoreBoard),
                SKAction.wait(forDuration: 0.75)
                ])
            ))
    }
    
    //
    //  runScoreBoard
    //
    
    func runScoreBoard() {
        if (gameScoreboard.remainingTime < 1) {
            backColor = SKColor.blue
            gameScoreboard.addLevel()
    
            pointsPerHit = gameScoreboard.gameLevel * 100
            pointsPerBankHit = gameScoreboard.gameLevel * 200

            if (gameScoreboard.gameLevel == energyGameLevel) {
                gameScoreboard.startTimer(timeOnEachLevel + 10)  // extra 10 seconds in the energy scene
                let coinScene = EnergyScene(size: self.size, score: gameScoreboard.score, scoreBoard: gameScoreboard, scene: self)
                let reveal = SKTransition.flipHorizontal(withDuration: 0.2)
                self.removeAllChildren()
                self.removeAllActions()
                self.view?.presentScene(coinScene, transition: reveal)
            }
            else {
                gameScoreboard.startTimer(timeOnEachLevel)
            }
            
            if (gameScoreboard.gameLevel == (lastGameLevel + 1)) {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.2)
                let gameOverScene = GameOverScene(size: self.size, score: gameScoreboard.score, scoreBoard: gameScoreboard)
            
                self.removeAllActions()
                self.removeAllChildren()
                self.view?.presentScene(gameOverScene, transition: reveal)
            }            
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
        //
        // if first body is a target and the second body a projectile
        //

        if (firstBody!.categoryBitMask == PhysicsCategory.Target) && (secondBody!.categoryBitMask == PhysicsCategory.Projectile) ||
            (firstBody!.categoryBitMask == PhysicsCategory.Projectile) && (secondBody!.categoryBitMask == PhysicsCategory.Target) {
                if let firstNode = firstBody?.node, let secondNode = secondBody?.node {
                    projectileDidCollideWithTarget(firstNode, second: secondNode)
                }
                else {
                }
        }
        else if (firstBody!.categoryBitMask == PhysicsCategory.Bomb) && (secondBody!.categoryBitMask == PhysicsCategory.Projectile) ||
            (firstBody!.categoryBitMask == PhysicsCategory.Projectile) && (secondBody!.categoryBitMask == PhysicsCategory.Bomb) {
            if let firstNode = firstBody?.node, let secondNode = secondBody?.node {
                projectileDidCollideWithTarget(firstNode, second: secondNode)
            }
            else {
            }
        }
        else if (firstBody!.categoryBitMask == PhysicsCategory.Bank) && (secondBody!.categoryBitMask == PhysicsCategory.Projectile) ||
            (firstBody!.categoryBitMask == PhysicsCategory.Projectile) && (secondBody!.categoryBitMask == PhysicsCategory.Bank) {
            if let firstNode = firstBody?.node, let secondNode = secondBody?.node {
                projectileDidCollideWithTarget(firstNode, second: secondNode)
            }
            else {
            }
        }
        else if (firstBody!.categoryBitMask == PhysicsCategory.Bomb) && (secondBody!.categoryBitMask == PhysicsCategory.MainActor) ||
            (firstBody!.categoryBitMask == PhysicsCategory.MainActor) && (secondBody!.categoryBitMask == PhysicsCategory.Bomb) {
                if let _ = firstBody?.node, let _ = secondBody?.node {
                    
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.2)
                    let gameOverScene = GameOverScene(size: self.size, score: gameScoreboard.score, scoreBoard: gameScoreboard)

                    self.removeAllActions()
                    self.removeAllChildren()
                    self.view?.presentScene(gameOverScene, transition: reveal)
                }
                else {
                }
        }
        else if (firstBody!.categoryBitMask == PhysicsCategory.Bank) && (secondBody!.categoryBitMask == PhysicsCategory.MainActor) ||
            (firstBody!.categoryBitMask == PhysicsCategory.MainActor) && (secondBody!.categoryBitMask == PhysicsCategory.Bank) {
            if let _ = firstBody?.node, let _ = secondBody?.node {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.2)
                let gameOverScene = GameOverScene(size: self.size, score: gameScoreboard.score, scoreBoard: gameScoreboard)
                self.view?.presentScene(gameOverScene, transition: reveal)
            }
            else {
            }
        }
    }
    
    //
    //  touchesEnded
    //
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        // shoot the projectile at the target
        
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = CGPoint(x: player.position.x, y: player.position.y + 5)
        projectile.zPosition = 0
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Target
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        let offset = touchLocation - projectile.position
        
        addChild(projectile)

        let direction = offset.normalized()
        let shootAmount = direction * 1000
        let realDest = shootAmount + projectile.position
        
        let actionMove = SKAction.move(to: realDest, duration: 0.75)
        let actionDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionDone]))
        
        projectile.run(gunshot)
    }
    
    //
    //  projectileDidCollideWithTarget
    //
    
    func projectileDidCollideWithTarget(_ first:SKNode, second:SKNode) {
        var isFace = false
        let firstSprite = first as! SKSpriteNode
        let secondSprite = second as! SKSpriteNode
        
        if (second.name == "bomb")  {
            self.run(explosion)
            gameScoreboard.addPoints(pointsPerBombHit)
        }
        else if (second.name == "hate") {
            isFace = true
            secondSprite.texture = SKTexture(imageNamed: "joyface64.png")
            first.removeFromParent()
            second.removeAllActions()
            gameScoreboard.addPoints(pointsPerHit)
        }
        else if (second.name == "bank") {
            self.run(explosion)
            gameScoreboard.addPoints(pointsPerBankHit)
        }
        else if (second.name == "cherry")
        {
            self.run(explosion)
            gameScoreboard.addPoints(pointsPerCherryHit)
        }
        else if (first.name == "bomb") {
            self.run(explosion)
            gameScoreboard.addPoints(pointsPerBombHit)
        }
        else if (first.name == "hate") {
            isFace = true
            firstSprite.texture = SKTexture(imageNamed: "joyface64.png")
            second.removeFromParent()
            first.removeAllActions()
            var gotoX = CGFloat(0.0)
            let gotoY = first.position.y
            if first.position.x < size.width / 2 {
            }
            else {
                gotoX = size.width
            }
            
            let actionMove = SKAction.move(to: CGPoint(x: gotoX , y: CGFloat(gotoY + 5.0)), duration: 0.5)
            
            let actionMoveDone = SKAction.removeFromParent()
            first.run(SKAction.sequence([actionMove, actionMoveDone]))
            
            gameScoreboard.addPoints(pointsPerHit)
        }
        else if (first.name == "bank") {
            self.run(explosion)
            gameScoreboard.addPoints(pointsPerBankHit)
        }
        else if (first.name == "cherry") {
            self.run(explosion)
            gameScoreboard.addPoints(pointsPerCherryHit)
        }
        
        if (!isFace) {
            let node1 = SKEmitterNode(fileNamed: "SparkExplosion.sks")
            node1!.position = first.position
            
            first.removeFromParent()
            second.removeFromParent()
            
            self.addChild(node1!)
            self.run(SKAction.wait(forDuration: 2), completion: { node1!.removeFromParent() })
        }
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    //
    //  addTarget
    //
    
    func addTarget() {

        let target1 = SKSpriteNode(imageNamed: "hate.png")
        let target2 = SKSpriteNode(imageNamed: "bomb64.png")
        let target3 = SKSpriteNode(imageNamed: "bank150.png")
        let target4 = SKSpriteNode(imageNamed: "cherry100.png")
        target1.name = "hate"
        target2.name = "bomb"
        target3.name = "bank"
        target4.name = "cherry"

        target1.zPosition = 0
        
        target1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(Target1Size),height: CGFloat(Target1Size)) )
        target1.physicsBody?.isDynamic = true
        target1.physicsBody?.categoryBitMask = PhysicsCategory.Target
        target1.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        target1.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        target2.zPosition = 0
        
        target2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(Target2Size),height: CGFloat(Target2Size)) )
        target2.physicsBody?.isDynamic = true
        target2.physicsBody?.categoryBitMask = PhysicsCategory.Bomb
        target2.physicsBody?.contactTestBitMask = PhysicsCategory.MainActor
        target2.physicsBody?.collisionBitMask = PhysicsCategory.None
                
        if (gameScoreboard.gameLevel > 1) {
            target3.zPosition = 0
            
            target3.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(Target3Size),height: CGFloat(Target3Size)) )
            target3.physicsBody?.isDynamic = true
            target3.physicsBody?.categoryBitMask = PhysicsCategory.Bank
            target3.physicsBody?.contactTestBitMask = PhysicsCategory.MainActor
            target3.physicsBody?.collisionBitMask = PhysicsCategory.None
        }
        
        //
        //  target 4 is cherry
        
        if (gameScoreboard.gameLevel > 2) {
            target4.zPosition = 0
            
            target4.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(Target4Size),height: CGFloat(Target4Size)) )
            target4.physicsBody?.isDynamic = true
            target4.physicsBody?.categoryBitMask = PhysicsCategory.Target
            target4.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
            target4.physicsBody?.collisionBitMask = PhysicsCategory.None
        }
        
        // Determine where to spawn the Target1 along the X axis
        let actualX = random(min: CGFloat(25), max: CGFloat(size.width - CGFloat(Target1Size/2)))
        let actualX2 = random(min: CGFloat(25), max: CGFloat(size.width - CGFloat(Target1Size/2)))

        // Position the Target slightly off-screen along the top,
        // and along a random position along the X axis as calculated above
        target1.position = CGPoint(x: actualX, y: size.width + CGFloat(Target1Size/2) + 300)
        target2.position = CGPoint(x: actualX2, y: size.width + CGFloat(Target2Size/2) + 300)
        
        // Add the targets to the scene
    
        addChild(target1)
        addChild(target2)
        if (gameScoreboard.gameLevel > 1) {
            let actualX3 = random(min: CGFloat(25), max: CGFloat(size.width - CGFloat(Target3Size/2)))
            target3.position = CGPoint(x: actualX3, y: size.width + CGFloat(Target3Size/2) + 300)
            addChild(target3)
            var actualDuration3 = random(min: CGFloat(1.0), max: CGFloat(2.0))
            if (gameScoreboard.gameLevel == energyGameLevel || gameScoreboard.gameLevel == (energyGameLevel + 1)) {
                actualDuration3 = random(min: CGFloat(3.0), max: CGFloat(4.0))
            }
            let actionMove3 = SKAction.move(to: CGPoint(x: actualX3 , y: -CGFloat(Target3Size/2)), duration: TimeInterval(actualDuration3))
            let actionMoveDone3 = SKAction.removeFromParent()
            target3.run(SKAction.sequence([actionMove3, actionMoveDone3]))
        }
        //
        //  target 4 is cherry
        //
        //
        if (gameScoreboard.gameLevel > 2) {
            let actualX41 = random(min: CGFloat(25), max: CGFloat(size.width/2 - 50))
            let actualX42 = random(min: CGFloat(size.width/2 + 50), max: CGFloat(size.width - 20))
            var actualX4: CGFloat
            let side = random(min:1, max:2)
            if (side < 1.5) {
                actualX4 = actualX41
            }
            else {
                actualX4 = actualX42
            }

            target4.position = CGPoint(x: actualX4, y: size.width + CGFloat(Target4Size/2) + 300)
            addChild(target4)
            let actualDuration4 = random(min: CGFloat(0.8), max: CGFloat(1.1))
            let actionMove4 = SKAction.move(to: CGPoint(x: actualX4 , y: -CGFloat(Target4Size/2)), duration: TimeInterval(actualDuration4))
            let actionMoveDone4 = SKAction.removeFromParent()
            target4.run(SKAction.sequence([actionMove4, actionMoveDone4]))
         
        }
        
        // Determine speed of the target
        let actualDuration = random(min: CGFloat(4.0), max: CGFloat(7.0))
        var actualDuration2 = random(min: CGFloat(5.0), max: CGFloat(6.0))
        if (gameScoreboard.gameLevel > 1) {
            actualDuration2 = random(min: CGFloat(3.0), max: CGFloat(4.0))
        }
        if (gameScoreboard.gameLevel > 2) {
            actualDuration2 = random(min: CGFloat(1.0), max: CGFloat(1.5))
        }
        if (gameScoreboard.gameLevel == energyGameLevel || gameScoreboard.gameLevel == (energyGameLevel + 1)) {
            actualDuration2 = random(min: CGFloat(3.0), max: CGFloat(4.0))
        }
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX , y: -CGFloat(Target1Size/2)), duration: TimeInterval(actualDuration))
        let actionMove2 = SKAction.move(to: CGPoint(x: actualX2 , y: -CGFloat(Target2Size/2)), duration: TimeInterval(actualDuration2))
        
        let actionMoveDone = SKAction.removeFromParent()
        let actionMoveDone2 = SKAction.removeFromParent()
        
        target1.run(SKAction.sequence([actionMove, actionMoveDone]))
        target2.run(SKAction.sequence([actionMove2, actionMoveDone2]))
    }
}


