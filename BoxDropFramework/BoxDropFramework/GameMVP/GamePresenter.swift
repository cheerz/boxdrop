import Foundation

class GamePresenter {

    private let model: Game.Model
    private weak var view: Game.View?

    init(model: Game.Model, view: Game.View) {
        self.model = model
        self.view = view
    }
}

// MARK: - Game.Presenter
extension GamePresenter: Game.Presenter {

}
