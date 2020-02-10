//
//  GameViewController.swift
//  MathGame
//
//  Created by Do Xuan Thanh on 1/1/19.
//  Copyright © 2019 monstar-lab. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

@available(iOS 11.0, *)
class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameOverScene(size: view.bounds.size, score: 0, initScreen: true)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
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

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
