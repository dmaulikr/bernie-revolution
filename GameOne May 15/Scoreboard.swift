//
//  Scoreboard.swift
//  GameOne
//
//  Created by David Lindsay on 11/10/15.
//
//
//   Scoreboard code is based on a heads up display from the book "Build iOS Games With Sprite Kit"
//

import SpriteKit
import Foundation

class Scoreboard : SKNode
{
    var _score: Int
    var _gameLevel: Int
    var startTime = NSDate.timeIntervalSinceReferenceDate()
    var elapsedTime: NSTimeInterval
    var gameTime: NSTimeInterval
    var remainingTime: NSTimeInterval {
        didSet {
        }
    }
    var count: Int
    var timer: NSTimeInterval {
        get {
            return elapsedTime
        }
        set(newValue) {
            elapsedTime = newValue
        }
    }
    
    var score: Int {
        get {
            return _score
        }
        
        set(newValue) {
            _score = newValue
        }
    }
    
    var gameLevel: Int {
        get {
            return _gameLevel
        }
        
        set(newValue) {
            _gameLevel = newValue
        }
    }
    
    func startTimer(time: Double) {
        startTime = NSDate.timeIntervalSinceReferenceDate()
        elapsedTime = 0.0
        gameTime = time
    }
    
    func resetGameLevel(resetValue: Int) {
        _gameLevel = resetValue
    }
    
    override init() {
        let formatter = NSNumberFormatter()

        _score = 0
        _gameLevel = 1
        elapsedTime = 0.0
        gameTime = timeOnEachLevel
        remainingTime = 0.0
        count = 0
        super.init()
        let scoreGroup = SKNode()
        scoreGroup.name = "scoreGroup"
        let scoreTitle = SKLabelNode(fontNamed: "Arial")
        scoreTitle.fontSize = 12
        scoreTitle.fontColor = SKColor.whiteColor()
        scoreTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        scoreTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        scoreTitle.text = "SCORE"
        scoreTitle.position = CGPointMake(0, 4)
        scoreGroup.addChild(scoreTitle)
        
        let scoreValue = SKLabelNode(fontNamed: "Arial")
        scoreValue.fontSize = 20
        scoreValue.fontColor = SKColor.whiteColor()
        scoreValue.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        scoreValue.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        scoreValue.name = "scoreValue"
        scoreValue.text = formatter.stringFromNumber(score)
        scoreValue.position = CGPointMake(0, -4)
        scoreGroup.addChild(scoreValue)
        self.addChild(scoreGroup)
        
        let elapsedGroup = SKNode()
        elapsedGroup.name = "elapsedGroup"
        let elapsedTitle = SKLabelNode(fontNamed: "Arial")
        elapsedTitle.fontSize = 12
        elapsedTitle.fontColor = SKColor.whiteColor()
        elapsedTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        elapsedTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        elapsedTitle.text = "TIME"
        elapsedTitle.position = CGPointMake(0, 4)
        elapsedGroup.addChild(elapsedTitle)
        let elapsedValue = SKLabelNode(fontNamed: "Arial")
        elapsedValue.fontSize = 20
        elapsedValue.fontColor = SKColor.whiteColor()
        elapsedValue.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        elapsedValue.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        elapsedValue.name = "elapsedValue"
        elapsedValue.text = "0.0s"
        elapsedValue.position = CGPointMake(0, -4)
        elapsedGroup.addChild(elapsedValue)
        self.addChild(elapsedGroup)
        
        let levelGroup = SKNode()
        levelGroup.position = CGPoint(x: 20.0, y: 20.0)
        levelGroup.name = "levelGroup"
        let levelTitle = SKLabelNode(fontNamed: "Arial")
        levelTitle.fontSize = 12
        levelTitle.fontColor = SKColor.whiteColor()
        levelTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        levelTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        levelTitle.text = "LEVEL"
        levelTitle.position = CGPointMake(0, 4)
        levelGroup.addChild(levelTitle)
        let levelValue = SKLabelNode(fontNamed: "Arial")
        levelValue.fontSize = 20
        levelValue.fontColor = SKColor.whiteColor()
        levelValue.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        levelValue.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        levelValue.name = "levelValue"
        levelValue.text = "1"
        levelValue.position = CGPointMake(0, -4)
        levelGroup.addChild(levelValue)
        self.addChild(levelGroup)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutForScene() {
        let sceneSize = self.scene!.size
        var groupSize = CGSizeZero
        let scoreGroup = childNodeWithName("scoreGroup")
        groupSize = scoreGroup!.calculateAccumulatedFrame().size
        scoreGroup?.position = CGPointMake(0 - sceneSize.width/2 + 20, sceneSize.height/2 - groupSize.height)
        print(sceneSize.width)
        
        print(scoreGroup?.position)
        
        let elapsedGroup = childNodeWithName("elapsedGroup")
        groupSize = elapsedGroup!.calculateAccumulatedFrame().size
        elapsedGroup?.position = CGPointMake(sceneSize.width/2 - 20, sceneSize.height/2 - groupSize.height)
        
        let levelGroup = childNodeWithName("levelGroup")
        groupSize = levelGroup!.calculateAccumulatedFrame().size
        levelGroup?.position = CGPointMake(sceneSize.width/2 - 60, sceneSize.height/2 - groupSize.height)
        
        print(elapsedGroup?.position)
    }
    
    func addPoints(points: Int) {
        let formatter = NSNumberFormatter()
        self.score += points
        
        let scoreValue: SKLabelNode = self.childNodeWithName("scoreGroup/scoreValue") as! SKLabelNode
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        scoreValue.text = formatter.stringFromNumber(score)
    }
    
    func addLevel () {
        let formatter = NSNumberFormatter()
        self.gameLevel += 1
        
        let levelValue: SKLabelNode = self.childNodeWithName("levelGroup/levelValue") as! SKLabelNode
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        levelValue.text = formatter.stringFromNumber(gameLevel)
    }
    
    func startScoreBoard () {
        let formatter = NSNumberFormatter()
        let elapsedValue = self.childNodeWithName("elapsedGroup/elapsedValue") as! SKLabelNode
        
        let update = SKAction.runBlock({
            let now = NSDate.timeIntervalSinceReferenceDate()
            let elapsed: NSTimeInterval = now - self.startTime
            self.elapsedTime = elapsed
            self.remainingTime = self.gameTime - elapsed
            let aString: String = formatter.stringFromNumber(self.remainingTime)!
            elapsedValue.text = aString.stringByReplacingOccurrencesOfString("-", withString: " ")
        })
        
        let delay = SKAction.waitForDuration(0.05)
        let updateAndDelay = SKAction.sequence([update,delay])
        let timer = SKAction.repeatActionForever(updateAndDelay)
        self.runAction(timer, withKey: "elapsedGameTimer")
    }
}


