//
// Created by maxime on 26/07/2018.
// Copyright (c) 2018 maxime. All rights reserved.
//

import UIKit

public class BoxDropLauncher {

    public static func startGame(in view: UIViewController) {
        let board = UIStoryboard(name: "GameViewController", bundle: Bundle(for: BoxDropLauncher.self))
        let vc = board.instantiateInitialViewController()!
        vc.modalPresentationStyle = .overCurrentContext
        view.present(vc, animated: true)
    }
}
