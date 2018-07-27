//
// Created by maxime on 26/07/2018.
// Copyright (c) 2018 maxime. All rights reserved.
//

import UIKit

public class BoxDropLauncher {

    public static func startGame(in viewController: UIViewController,
                                 with model: GameUploadingModelProtocol,
                                 navigator: GameUploadingNavigator,
                                 action: GameUploadingCompletion?) {
        let board = UIStoryboard(name: "GameViewController",
                                 bundle: Bundle(for: BoxDropLauncher.self))
        guard let gameViewController = board.instantiateInitialViewController() as? GameViewController else { return }
        let presenter = GamePresenter(model: model, view: gameViewController, navigator: navigator, action: action)
        gameViewController.modalPresentationStyle = .overCurrentContext
        gameViewController.presenter = presenter
        viewController.present(gameViewController, animated: true)
    }
}
