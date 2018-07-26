//
// Created by maxime on 26/07/2018.
// Copyright (c) 2018 maxime. All rights reserved.
//

import UIKit

public class BoxDropLauncher {

    public static func startGame(in viewController: UIViewController) {
        let board = UIStoryboard(name: "GameViewController",
                                 bundle: Bundle(for: BoxDropLauncher.self))
        guard let gameViewController = board.instantiateInitialViewController() as? GameViewController else { return }
        gameViewController.modalPresentationStyle = .overCurrentContext

        let model = GameModel()
        let presenter = GamePresenter(model: model, view: gameViewController)
        gameViewController.presenter = presenter
        viewController.present(gameViewController, animated: true)
    }
}
