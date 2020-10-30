//
//  GameOverScene.swift
//  Sprytz Flight
//
//  Created by Danny on 22/09/2015.
//  Copyright © 2015 Danny Gillespie. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import GameKit

class GameOverScene: SKScene {
    
    var deathSong = AVAudioPlayer()
    
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
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        scene!.size = self.view!.frame.size
        
        deathSong = self.setupAudioPlayerWithFile("deathSong", type:"mp3")
        deathSong.numberOfLoops = -1
        
        let lastScore = NSUserDefaults.standardUserDefaults().integerForKey("lastScore")
        let highScore = NSUserDefaults.standardUserDefaults().integerForKey("highScore")
        
        let backgroundImage = SKSpriteNode(imageNamed: "gameOverScreen")
        backgroundImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        backgroundImage.size = CGSize(width: self.size.width, height: self.size.height)
        backgroundImage.zPosition = 0
        
        let lastScoreLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Heavy")
        lastScoreLabel.position = CGPoint (x: self.size.width * 0.50, y: self.size.height * 0.33)
        lastScoreLabel.fontSize = self.size.width * 0.10
        lastScoreLabel.fontColor = SKColor.blackColor()
        lastScoreLabel.text = "\(lastScore)"
        lastScoreLabel.zPosition = 10
        
        let highScoreLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Heavy")
        highScoreLabel.position = CGPoint (x: self.size.width * 0.50, y: self.size.height * 0.18)
        highScoreLabel.fontSize = self.size.width * 0.10
        highScoreLabel.fontColor = SKColor.blackColor()
        highScoreLabel.text = "\(highScore)"
        highScoreLabel.zPosition = 10
        
        let playGameButton = SKSpriteNode(imageNamed: "playButton")
        playGameButton.position = CGPoint (x: size.width * 0.72, y: size.height * 0.06)
        playGameButton.setScale(self.size.width / 1000)
        playGameButton.name = "playGameButton"
        playGameButton.zPosition = 10
        
        let homeButton = SKSpriteNode(imageNamed: "homeButton")
        homeButton.position = CGPoint (x: size.width * 0.28, y: size.height * 0.06)
        homeButton.setScale(self.size.width / 1000)
        homeButton.name = "homeButton"
        homeButton.zPosition = 10
        
        addChild(backgroundImage)
        addChild(homeButton)
        addChild(playGameButton)
        addChild(highScoreLabel)
        addChild(lastScoreLabel)
        
        deathSong.play()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches
        let location = touch.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        // If play button is touched start game again
        if (node.name == "playGameButton") {
            let gamePlayScene = GamePlayScene()
            let transition = SKTransition.fadeWithColor(UIColor.blackColor(), duration: 0.5)
            self.scene!.view?.presentScene(gamePlayScene, transition: transition)
            deathSong.stop()
        }
        if (node.name == "homeButton") {
            let homeScene = HomeScene()
            let transition = SKTransition.fadeWithColor(UIColor.blackColor(), duration: 0.5)
            self.scene!.view?.presentScene(homeScene, transition: transition)
            deathSong.stop()
        }
        
    }
}