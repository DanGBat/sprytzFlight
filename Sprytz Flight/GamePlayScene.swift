//
//  GamePlayScene.swift
//  Sprytz Flight
//
//  Created by Danny on 22/09/2015.
//  Copyright © 2015 Danny Gillespie. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import GameKit

class GamePlayScene: SKScene, SKPhysicsContactDelegate {
    
    let backgroundVelocity : CGFloat = 0.8
    let sidesVelocity : CGFloat = 6.0
    let playerSprite = SKSpriteNode(imageNamed: "spritePlayer")
    var mainGameMusic = AVAudioPlayer()
    var turnPlayer = SKAction.playSoundFileNamed("playerTurn.mp3", waitForCompletion: false)
    var sideDeath = AVAudioPlayer()
    var ghostDeath = AVAudioPlayer()
    var score = -1
    let scoreLabel = SKLabelNode(fontNamed: "Verdana-BoldItalic")
    
    struct PhysicsCategory {
        static let None     : UInt32 = 0x1 << 0
        static let Sprite   : UInt32 = 0x1 << 1
        static let Enemy    : UInt32 = 0x1 << 2
        static let Wall     : UInt32 = 0x1 << 3
        static let Floor    : UInt32 = 0x1 << 4
    }
    
    //setup Audio Player
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer  {
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        var audioPlayer:AVAudioPlayer?
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
            } catch {
            print("NO AUDIO PLAYER")
            }
        return audioPlayer!
    }
    
    //set up distant scrolling background
    func initializingScrollingBackground() {
        for var index = 0; index < 2; ++index {
            let bg = SKSpriteNode(imageNamed: "backgroundPlanets")
            bg.size = CGSize(width: frame.size.width, height: frame.size.height)
            bg.position = CGPoint(x: Int(frame.size.width/2), y: index * Int(bg.size.height))
            bg.zPosition = 0
            bg.name = "background"
            self.addChild(bg)
        }
    }
    
    //set up side scrolling sides
    func initializingScrollingSides() {
        for var index = 0; index < 2; ++index {
            let sides = SKSpriteNode(imageNamed: "backgroundSides")
            sides.size = CGSize(width: self.size.width, height: self.size.height)
            sides.position = CGPoint(x: Int(frame.size.width/2), y: index * Int(sides.size.height))
            sides.zPosition = 1
            sides.name = "sides"
            self.addChild(sides)
        }
    }
    
    //Function to move distant background up
    func moveBackground() {
        self.enumerateChildNodesWithName("background", usingBlock: { (node, stop) -> Void in
            if let bg = node as? SKSpriteNode {
                bg.position = CGPoint(x: bg.position.x, y: bg.position.y - self.backgroundVelocity)
                // Checks if bg node is completely scrolled off the screen, if yes, then puts it at the end of the other node.
                if bg.position.y <= bg.size.height - bg.size.height * 1.5 {
                    bg.position = CGPointMake(bg.position.x, bg.position.y + bg.size.height*2)
                }
            }
        })
    }
    
    //Function to move scrolling sides up
    func moveSides() {
        self.enumerateChildNodesWithName("sides", usingBlock: { (node, stop) -> Void in
            if let sides = node as? SKSpriteNode {
                sides.position = CGPoint(x: sides.position.x, y: sides.position.y - self.sidesVelocity)
                // Checks if bg node is completely scrolled off the screen, if yes, then puts it at the end of the other node.
                if sides.position.y <= sides.size.height - sides.size.height * 1.5 {
                    sides.position = CGPointMake(sides.position.x, sides.position.y + sides.size.height*2)
                }
            }
        })
    }
    
    //create random funcions for enemySprites
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    //set up enemySprite function
    func addEnemySprite() {
        let enemySprite = SKSpriteNode(imageNamed: "spriteEnemy")
        let actualX = random(min: enemySprite.size.width/2, max: size.width - enemySprite.size.width/2)
        enemySprite.position = CGPoint(x: actualX, y: size.height + enemySprite.size.height/2)
        enemySprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: enemySprite.size.width * 0.70, height: enemySprite.size.height * 0.55))
        enemySprite.physicsBody?.dynamic = false
        enemySprite.physicsBody?.restitution = 0.0
        enemySprite.physicsBody?.friction = 0.0
        enemySprite.physicsBody?.linearDamping = 0.0
        enemySprite.physicsBody?.angularDamping = 0.0
        enemySprite.physicsBody?.allowsRotation = false
        enemySprite.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        enemySprite.physicsBody?.contactTestBitMask = PhysicsCategory.Sprite
        enemySprite.physicsBody?.collisionBitMask = PhysicsCategory.Enemy
        enemySprite.physicsBody?.usesPreciseCollisionDetection = false
        enemySprite.setScale(self.size.width / 1400)
        enemySprite.zPosition = 10
        enemySprite.name = "spriteEnemy"
        
        addChild(enemySprite)
        
        let actualDuration = random(min: CGFloat(1.4), max: CGFloat(4.0))
        let actionMove = SKAction.moveTo(CGPoint(x: actualX, y: -enemySprite.size.height/2), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        enemySprite.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    //add Control Instructions
    func addControlInstructions() {
        let tapLeftRight = SKSpriteNode(imageNamed: "tapLeftRight")
        tapLeftRight.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.1)
        tapLeftRight.setScale((self.size.width / (self.size.height * 1.5)))
        tapLeftRight.zPosition = 50
        tapLeftRight.alpha = 0.3
        addChild(tapLeftRight)
        
        tapLeftRight.runAction(SKAction.sequence([SKAction.waitForDuration(3.5), SKAction.fadeOutWithDuration(2.0), SKAction.removeFromParent()]))
    }
    
    func ghostDeathSequence() {
        playerSprite.alpha = 0.3
        mainGameMusic.stop()
        ghostDeath.play()
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        saveHighscore(score)
        let gameOverScene = GameOverScene()
        let transition = SKTransition.fadeWithColor(UIColor.blackColor(), duration: 1.5)
        self.scene!.view?.presentScene(gameOverScene, transition: transition)
    }
    
    func sideDeathSequence() {
        playerSprite.alpha = 0.3
        mainGameMusic.stop()
        ghostDeath.play()
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        saveHighscore(score)
        let gameOverScene = GameOverScene()
        let transition = SKTransition.fadeWithColor(UIColor.blackColor(), duration: 1.5)
        self.scene!.view?.presentScene(gameOverScene, transition: transition)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        scene!.size = self.view!.frame.size
        physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        physicsWorld.contactDelegate = self
        
        //Set Up Sounds Ready To Be Called
        mainGameMusic = self.setupAudioPlayerWithFile("mainGameMusic", type:"mp3")
        mainGameMusic.numberOfLoops = -1
        ghostDeath = self.setupAudioPlayerWithFile("ghostDeath", type:"mp3")
        sideDeath = self.setupAudioPlayerWithFile("sideDeath", type:"mp3")
        
        let leftWall = SKShapeNode(rectOfSize: CGSize(width: 30, height: size.height))
        leftWall.position = CGPoint(x: size.width - size.width, y: size.height * 0.5)
        leftWall.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.size.width * 0.08, height: size.height))
        leftWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        leftWall.physicsBody?.contactTestBitMask = PhysicsCategory.Sprite
        leftWall.physicsBody?.collisionBitMask = 0
        let RightWall = SKShapeNode(rectOfSize: CGSize(width: 30, height: size.height))
        RightWall.position = CGPoint(x: size.width, y: size.height * 0.5)
        RightWall.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.size.width * 0.08, height: size.height))
        RightWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        RightWall.physicsBody?.contactTestBitMask = PhysicsCategory.Sprite
        RightWall.physicsBody?.collisionBitMask = 0
        let floor = SKShapeNode(rectOfSize: CGSize(width: size.width, height: 1))
        floor.position = CGPoint(x: size.width * 0.5, y: self.size.height * 0.3)
        floor.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: size.width, height: 1))
        floor.physicsBody?.categoryBitMask = PhysicsCategory.Floor
        floor.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        floor.physicsBody?.collisionBitMask = 0
        
        addChild(leftWall)
        addChild(RightWall)
        addChild(floor)
        
        playerSprite.position = CGPoint(x: self.size.width * 0.3, y: self.size.height * 0.3)
        playerSprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: playerSprite.size.width * 0.70, height: playerSprite.size.height * 0.55))
        playerSprite.physicsBody?.dynamic = true
        playerSprite.physicsBody?.restitution = 0.0
        playerSprite.physicsBody?.friction = 0.0
        playerSprite.physicsBody?.linearDamping = 0.0
        playerSprite.physicsBody?.angularDamping = 0.0
        playerSprite.physicsBody?.allowsRotation = false
        playerSprite.physicsBody?.categoryBitMask = PhysicsCategory.Sprite
        playerSprite.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        playerSprite.physicsBody?.collisionBitMask = PhysicsCategory.Sprite
        playerSprite.setScale(self.size.width / 1400)
        playerSprite.zPosition = 10
        playerSprite.name = "spritePlayer"
        
        self.initializingScrollingBackground()
        self.initializingScrollingSides()
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addEnemySprite),
                SKAction.waitForDuration(0.7)
                ])
            ))
        
        addChild(playerSprite)
        addControlInstructions()
        
        playerSprite.physicsBody!.velocity = CGVectorMake(100, 0)
        
        scoreLabel.position = CGPoint (x: self.size.width * 0.50, y: self.size.height * 0.8)
        scoreLabel.fontSize = self.size.width * 0.15
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.alpha = 0.35
        scoreLabel.zPosition = 30
        addChild(scoreLabel)
        
        addScore()
        
        mainGameMusic.play()
    }
    
    //Game Score and High Score functions
    func addScore() {
        score += 1
        scoreLabel.text = "\(score)"
        
        let lastScore = NSUserDefaults.standardUserDefaults().integerForKey("lastScore")
        NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "lastScore")
        let highScore = NSUserDefaults.standardUserDefaults().integerForKey("highScore")
        //Check if score is higher than NSUserDefaults stored value and change NSUserDefaults stored value if it's true
        if score > NSUserDefaults.standardUserDefaults().integerForKey("highScore") {
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "highScore")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        NSUserDefaults.standardUserDefaults().integerForKey("highScore")
        print(lastScore)
        print(highScore)
    }
    
    //Send High Score to leaderboard
    func saveHighscore(highScore:Int) {
        //check if user is signed in first
        if GKLocalPlayer.localPlayer().authenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "sprytzflightleaderboard123") //leaderboard id here
            scoreReporter.value = Int64(highScore) //score variable here (same as above)
            let scoreArray: [GKScore] = [scoreReporter]
            GKScore.reportScores(scoreArray, withCompletionHandler: {error -> Void in
                if error != nil {
                    print("score send error")
                }
            })
        }
    }
    
    //This is the method that passes the bodies colliding
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == PhysicsCategory.Sprite && contact.bodyB.categoryBitMask == PhysicsCategory.Enemy ||
            contact.bodyA.categoryBitMask == PhysicsCategory.Sprite && contact.bodyB.categoryBitMask == PhysicsCategory.Wall {
                print("Ghost Contact made")
                ghostDeathSequence()
        }
        else if contact.bodyA.categoryBitMask == PhysicsCategory.Enemy && contact.bodyB.categoryBitMask == PhysicsCategory.Sprite ||
            contact.bodyA.categoryBitMask == PhysicsCategory.Wall && contact.bodyB.categoryBitMask == PhysicsCategory.Sprite {
                print("Side Contact made")
                sideDeathSequence()
        }
        if contact.bodyA.categoryBitMask == PhysicsCategory.Enemy && contact.bodyB.categoryBitMask == PhysicsCategory.Floor ||
            contact.bodyA.categoryBitMask == PhysicsCategory.Floor && contact.bodyB.categoryBitMask == PhysicsCategory.Enemy {
                print("Enemy Left")
                addScore()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if location.x > frame.size.width/2 {
                //function for flying right (with flip)
                playerSprite.physicsBody!.velocity = CGVectorMake(self.size.width * 1.0, 0)
                playerSprite.xScale = fabs(playerSprite.xScale) * 1
                runAction(turnPlayer)

            } else {
                //function for flying left (with flip)
                playerSprite.physicsBody!.velocity = CGVectorMake(self.size.width * -1.0, 0)
                playerSprite.xScale = fabs(playerSprite.xScale) * -1
                runAction(turnPlayer)
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        self.moveBackground()
        self.moveSides()
    }
}
