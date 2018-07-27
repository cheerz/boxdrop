//
//  GameViewController.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(_ file: String) -> SKNode? {

        let path = Bundle(for: BoxDropLauncher.self).path(forResource: file, ofType: "sks")

        let sceneData: Data?
        do {
            sceneData = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        } catch _ {
            sceneData = nil
        }
        let archiver = NSKeyedUnarchiver(forReadingWith: sceneData!)

        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
        archiver.finishDecoding()
        return scene
    }
}

class GameViewController: UIViewController {

    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var closeButtonLabel: UILabel!

    var presenter: Game.Presenter?

    private enum Font: String {
        case nunitoSemiBold = "Nunito-SemiBold"
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        progressView.setProgress(0, animated: false)

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView

            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true

            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill

            skView.presentScene(scene)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.onViewDidAppear()
    }

    // MARK: - Device orientation

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.allButUpsideDown
        } else {
            return UIInterfaceOrientationMask.all
        }
    }

    // MARK: Setup UI

    func setupUI() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        closeButtonLabel.font = UIFont.getCustomFont(name: Font.nunitoSemiBold.rawValue,
                                                     size: 17.0,
                                                     bundle: Bundle(for: GameViewController.self),
                                                     type: .trueTypeFont)
    }

    // MARK: IBAction

    @IBAction func closeView(_ sender: UIButton) {
        presenter?.onStopButtonTapped()
    }
}


// MARK: - Game.View
extension GameViewController: Game.View {

    func updateProgressView(value: Float) {
        progressView.setProgress(value, animated: true)
    }

    func updatePreview(image: UIImage) {
        previewImageView.image = image
    }
}

