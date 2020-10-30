//
//  HomeScene.swift
//  Sprytz Flight
//
//  Created by Danny on 22/09/2015.
//  Copyright © 2015 Danny Gillespie. All rights reserved.
//

import SpriteKit
import AVFoundation
import GameKit

class HomeScene: SKScene, GKGameCenterControllerDelegate {
    
    var homeScreenMusic = AVAudioPlayer()
    
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
        
        homeScreenMusic = self.setupAudioPlayerWithFile("homeScreenMusic", type:"mp3")
        homeScreenMusic.numberOfLoops = -1
        
        let backgroundImage = SKSpriteNode(imageNamed: "homeScreen")
        backgroundImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        backgroundImage.size = CGSize(width: self.size.width, height: self.size.height)
        backgroundImage.zPosition = 0
        
        let payButton = SKSpriteNode(imageNamed: "spritePay")
        payButton.position = CGPoint (x: size.width * 0.20, y: size.height * 0.22)
        payButton.setScale(self.size.width / 1200)
        payButton.name = "payButton"
        payButton.zPosition = 10
        
        let infoButton = SKSpriteNode(imageNamed: "spriteInfo")
        infoButton.position = CGPoint (x: size.width * 0.40, y: size.height * 0.22)
        infoButton.setScale(self.size.width / 1200)
        infoButton.name = "infoButton"
        infoButton.zPosition = 10
        
        let websiteButton = SKSpriteNode(imageNamed: "spriteWebsite")
        websiteButton.position = CGPoint (x: size.width * 0.60, y: size.height * 0.22)
        websiteButton.setScale(self.size.width / 1200)
        websiteButton.name = "websiteButton"
        websiteButton.zPosition = 10
        
        let gameCenterButton = SKSpriteNode(imageNamed: "spriteTrophy")
        gameCenterButton.position = CGPoint (x: size.width * 0.80, y: size.height * 0.22)
        gameCenterButton.setScale(self.size.width / 1200)
        gameCenterButton.name = "gameCenterButton"
        gameCenterButton.zPosition = 10
        
        let playGameButton = SKSpriteNode(imageNamed: "playButton")
        playGameButton.position = CGPoint (x: size.width * 0.50, y: size.height * 0.07)
        playGameButton.setScale(self.size.width / 1000)
        playGameButton.name = "playGameButton"
        playGameButton.zPosition = 10
        
        addChild(backgroundImage)
        addChild(payButton)
        addChild(infoButton)
        addChild(websiteButton)
        addChild(gameCenterButton)
        addChild(playGameButton)
        
        homeScreenMusic.play()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches
        let location = touch.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        // If info button is touched
        if (node.name == "infoButton") {
            homeScreenMusic.stop()
            let infoScene = InfoScene()
            let transition = SKTransition.fadeWithColor(UIColor.blackColor(), duration: 0.5)
            self.scene!.view?.presentScene(infoScene, transition: transition)
        }
        // If danGBat button is touched
        if (node.name == "websiteButton") {
            print("Linked to DanGBat site")
            UIApplication.sharedApplication().openURL(NSURL(string: "http://www.dangbat.co.uk")!)
        }
        // If Game Center button is touched show leaderboard
        if (node.name == "gameCenterButton") {
            print("Game Center Leaderboard Displayed")
            showLeader()
        }
        // If play button is touched start game again
        if (node.name == "playGameButton") {
            print("Display Game Scene")
            homeScreenMusic.stop()
            let gamePlayScene = GamePlayScene()
            let transition = SKTransition.fadeWithColor(UIColor.blackColor(), duration: 0.5)
            self.scene!.view?.presentScene(gamePlayScene, transition: transition)
        }
    }
    
    //shows leaderboard screen
    func showLeader() {
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }

}