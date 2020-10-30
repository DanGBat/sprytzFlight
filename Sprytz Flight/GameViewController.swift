//
//  GameViewController.swift
//  Sprytz Flight
//
//  Created by Danny on 22/09/2015.
//  Copyright (c) 2015 Danny Gillespie. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import iAd
import AVFoundation.AVAudioSession

class GameViewController: UIViewController, ADBannerViewDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //Creates reference to the AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let scene = HomeScene(fileNamed:"HomeScene") {
            // Configure the view.
            let skView = self.view as! SKView
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            //skView.showsPhysics = true
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
        
        //Allows the user to play their own background music
        do
        {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error as NSError
        {
            print(error)
        }
        
        loadAds()
        authenticateLocalPlayer()
    }
    
    //setup banner Ads
        func loadAds() {
        self.appDelegate.adBannerView.removeFromSuperview()
        self.appDelegate.adBannerView.delegate = nil
        self.appDelegate.adBannerView = ADBannerView(frame: CGRect.zero)
        self.appDelegate.adBannerView.center = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height - view.bounds.size.height + self.appDelegate.adBannerView.frame.size.height / 2)
        self.appDelegate.adBannerView.delegate = self
        self.appDelegate.adBannerView.hidden = true
        view.addSubview(self.appDelegate.adBannerView)
    }
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        print("bannerViewDidLoadAd")
        self.appDelegate.adBannerView.hidden = false
    }
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        print("bannerViewActionDidFinish")
    }
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        print("didFailToReceiveAdWithError")
        self.appDelegate.adBannerView.hidden = true
    }

    //initiate Gamecenter Login
    func authenticateLocalPlayer(){
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                self.presentViewController(viewController!, animated: true, completion: nil)
                print("Game Center Failed")
            }
            else {
                print((GKLocalPlayer.localPlayer().authenticated))
                print("Game Center Sucessful Log in")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
