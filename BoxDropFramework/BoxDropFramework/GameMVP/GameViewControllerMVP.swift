import UIKit

enum Game {
    typealias Model     = GameModelProtocol
    typealias View      = GameViewProtocol
    typealias Presenter = GamePresenterProtocol
}

protocol GameModelProtocol {

}

protocol GameViewProtocol: class {

    func updateProgressView(value: Float)

    func updatePreview(image: UIImage)
}

protocol GamePresenterProtocol {

}
