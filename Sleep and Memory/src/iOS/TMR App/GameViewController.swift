//
//  GameViewController.swift
//  TMR App
//
//  Created by Robert Zhang on 6/5/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = TMRScreen(size: CGSize(width:self.view.frame.width*2, height:self.view.frame.height*2)) //Change "GameScene" to the name of the class you want to start the app. Right now, GameScene starts the app
        scene.viewCtrl = self
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        scene.size = self.view.bounds.size
        skView.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
