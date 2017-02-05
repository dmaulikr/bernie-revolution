//
//  Scoreboard.swift
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
    var startTime = Date.timeIntervalSinceReferenceDate
    var elapsedTime: TimeInterval
    var gameTime: TimeInterval
    var remainingTime: TimeInterval {
        didSet {
        }
    }
    var count: Int
    var timer: TimeInterval {
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
    
    func startTimer(_ time: Double) {
        startTime = Date.timeIntervalSinceReferenceDate
        elapsedTime = 0.0
        gameTime = time
    }
    
    func resetGameLevel(_ resetValue: Int) {
        _gameLevel = resetValue
    }
    
    override init() {
        let formatter = NumberFormatter()

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
        scoreTitle.fontColor = SKColor.white
        scoreTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
        scoreTitle.text = "SCORE"
        scoreTitle.position = CGPoint(x: 0, y: 4)
        scoreGroup.addChild(scoreTitle)
        
        let scoreValue = SKLabelNode(fontNamed: "Arial")
        scoreValue.fontSize = 20
        scoreValue.fontColor = SKColor.white
        scoreValue.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreValue.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        scoreValue.name = "scoreValue"
        scoreValue.text = formatter.string(from: NSNumber(value: score))
        scoreValue.position = CGPoint(x: 0, y: -4)
        scoreGroup.addChild(scoreValue)
        self.addChild(scoreGroup)
        
        let elapsedGroup = SKNode()
        elapsedGroup.name = "elapsedGroup"
        let elapsedTitle = SKLabelNode(fontNamed: "Arial")
        elapsedTitle.fontSize = 12
        elapsedTitle.fontColor = SKColor.white
        elapsedTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        elapsedTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
        elapsedTitle.text = "TIME"
        elapsedTitle.position = CGPoint(x: 0, y: 4)
        elapsedGroup.addChild(elapsedTitle)
        let elapsedValue = SKLabelNode(fontNamed: "Arial")
        elapsedValue.fontSize = 20
        elapsedValue.fontColor = SKColor.white
        elapsedValue.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        elapsedValue.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        elapsedValue.name = "elapsedValue"
        elapsedValue.text = "0.0s"
        elapsedValue.position = CGPoint(x: 0, y: -4)
        elapsedGroup.addChild(elapsedValue)
        self.addChild(elapsedGroup)
        
        let levelGroup = SKNode()
        levelGroup.position = CGPoint(x: 20.0, y: 20.0)
        levelGroup.name = "levelGroup"
        let levelTitle = SKLabelNode(fontNamed: "Arial")
        levelTitle.fontSize = 12
        levelTitle.fontColor = SKColor.white
        levelTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        levelTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
        levelTitle.text = "LEVEL"
        levelTitle.position = CGPoint(x: 0, y: 4)
        levelGroup.addChild(levelTitle)
        let levelValue = SKLabelNode(fontNamed: "Arial")
        levelValue.fontSize = 20
        levelValue.fontColor = SKColor.white
        levelValue.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        levelValue.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        levelValue.name = "levelValue"
        levelValue.text = "1"
        levelValue.position = CGPoint(x: 0, y: -4)
        levelGroup.addChild(levelValue)
        self.addChild(levelGroup)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutForScene() {
        let sceneSize = self.scene!.size
        var groupSize = CGSize.zero
        let scoreGroup = childNode(withName: "scoreGroup")
        groupSize = scoreGroup!.calculateAccumulatedFrame().size
        scoreGroup?.position = CGPoint(x: 0 - sceneSize.width/2 + 20, y: sceneSize.height/2 - groupSize.height)
        
        let elapsedGroup = childNode(withName: "elapsedGroup")
        groupSize = elapsedGroup!.calculateAccumulatedFrame().size
        elapsedGroup?.position = CGPoint(x: sceneSize.width/2 - 20, y: sceneSize.height/2 - groupSize.height)
        
        let levelGroup = childNode(withName: "levelGroup")
        groupSize = levelGroup!.calculateAccumulatedFrame().size
        levelGroup?.position = CGPoint(x: sceneSize.width/2 - 60, y: sceneSize.height/2 - groupSize.height)
    }
    
    func addPoints(_ points: Int) {
        let formatter = NumberFormatter()
        self.score += points
        let scoreValue: SKLabelNode = self.childNode(withName: "scoreGroup/scoreValue") as! SKLabelNode
        formatter.numberStyle = NumberFormatter.Style.decimal
        scoreValue.text = formatter.string(from: NSNumber(value: score))
    }
    
    func addLevel () {
        let formatter = NumberFormatter()
        self.gameLevel += 1
        let levelValue: SKLabelNode = self.childNode(withName: "levelGroup/levelValue") as! SKLabelNode
        formatter.numberStyle = NumberFormatter.Style.decimal
        levelValue.text = formatter.string(from: NSNumber(value: gameLevel))
    }
    
    func startScoreBoard () {
        let formatter = NumberFormatter()
        let elapsedValue = self.childNode(withName: "elapsedGroup/elapsedValue") as! SKLabelNode
        
        let update = SKAction.run({
            let now = Date.timeIntervalSinceReferenceDate
            let elapsed: TimeInterval = now - self.startTime
            self.elapsedTime = elapsed
            self.remainingTime = self.gameTime - elapsed
            let aString: String = formatter.string(from: NSNumber(value: self.remainingTime))!
            elapsedValue.text = aString.replacingOccurrences(of: "-", with: " ")
        })
        
        let delay = SKAction.wait(forDuration: 0.05)
        let updateAndDelay = SKAction.sequence([update,delay])
        let timer = SKAction.repeatForever(updateAndDelay)
        self.run(timer, withKey: "elapsedGameTimer")
    }
}


