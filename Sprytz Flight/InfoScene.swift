//
//  InfoScene.swift
//  Sprytz Flight
//
//  Created by Danny on 22/09/2015.
//  Copyright © 2015 Danny Gillespie. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class InfoScene: SKScene {
    
    //Animated Text Setup
    func animatedTextSetup() {
        
        sprytzFlightVocal = self.setupAudioPlayerWithFile("SprytzFlightVocal", type:"mp3")
        sprytzFlightVocal.play()
        
        var AnimatedText : SKSpriteNode!
        var textAnimatedFrames : [SKTexture]!
        let animatedTextAtlas = SKTextureAtlas(named: "AnimatedText")
        var animateFrames = [SKTexture]()
        let numImages = animatedTextAtlas.textureNames.count
        for var i=1; i<=numImages; i++ {
        let textTextureName = "SprytzAnimatedText\(i)"
        animateFrames.append(animatedTextAtlas.textureNamed(textTextureName))
        }
        textAnimatedFrames = animateFrames
        let firstFrame = textAnimatedFrames[0]
        AnimatedText = SKSpriteNode(texture: firstFrame)
        AnimatedText.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.25)
        AnimatedText.setScale(self.size.width / 1850)
        addChild(AnimatedText)
        //Animate Text Function
        func runAnimatedText() {
            AnimatedText.runAction(
                SKAction.animateWithTextures(textAnimatedFrames, timePerFrame: 0.14, resize: true,
                    restore: true))
        }
        runAnimatedText()
        }
    
    var sprytzFlightVocal = AVAudioPlayer()
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
        
        let backgroundImage = SKSpriteNode(imageNamed: "infoScreen")
        backgroundImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        backgroundImage.size = CGSize(width: self.size.width, height: self.size.height)
        backgroundImage.zPosition = -10
        
        let danGBat = SKSpriteNode(imageNamed: "spriteDanGBat")
        danGBat.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.35)
        danGBat.setScale(self.size.width / 1200)
        danGBat.name = "danGBat"
        danGBat.zPosition = 10
        
        let twitter = SKSpriteNode(imageNamed: "spriteTwitter")
        twitter.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.16)
        twitter.setScale(self.size.width / 1200)
        twitter.name = "twitter"
        twitter.zPosition = 10
        
        let facebook = SKSpriteNode(imageNamed: "spriteFacebook")
        facebook.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.09)
        facebook.setScale(self.size.width / 1200)
        facebook.name = "facebook"
        facebook.zPosition = 10
        
        addChild(danGBat)
        addChild(twitter)
        addChild(facebook)
        addChild(backgroundImage)
        
        animatedTextSetup()
        }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let homeScene = HomeScene()
        let transition = SKTransition.fadeWithColor(UIColor.blackColor(), duration: 0.5)
        self.scene!.view?.presentScene(homeScene, transition: transition)
        
        let touch = touches
        let location = touch.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        // If dangbat button is touched
        if (node.name == "danGBat") {
            UIApplication.sharedApplication().openURL(NSURL(string: "http://www.dangbat.co.uk")!)
            }
        // If twitter button is touched
        if (node.name == "twitter") {
            UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/SprytzFlight")!)
        }
        // If facebook button is touched
        if (node.name == "facebook") {
            UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/SprytzFlight")!)
        }
        }
}