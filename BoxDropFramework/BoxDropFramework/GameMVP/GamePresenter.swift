import Foundation

class GamePresenter {

    private let model: Game.Model
    private weak var view: Game.View?
    private let navigator: GameUploadingNavigator
    private let action: GameUploadingCompletion?

    init(model: Game.Model, view: Game.View, navigator: GameUploadingNavigator, action: GameUploadingCompletion?) {
        self.model = model
        self.view = view
        self.navigator = navigator
        self.action = action
        self.model.setProgressListener(with: self)
    }

    private func updateProgressView() {
        if model.newImageNeeded() {
            view?.updatePreview(image: UIImage(named: "icon_placeholder_selection")!)
            model.getCurrentImage { image in
                guard let image = image else { return }
                self.view?.updatePreview(image: image)
            }
        }
        view?.updateProgressView(value: model.getTotalProgress())
    }

    private func checkUploadStatus() {
        if model.isUploadedOrFailed() {
            model.resetUploadIfNeeded()
        } else {
            self.updateProgressView()
        }
    }
}

// MARK: - Game.Presenter
extension GamePresenter: Game.Presenter {

    func onViewDidAppear() {
        model.resetUploadIfNeeded()
    }

    func onStopButtonTapped() {
        if model.isUploadComplete() {
            navigator.showNextView(action: action)
        } else {
            navigator.showPreviousView()
        }
    }
}

extension GamePresenter: GameUploadingProgressListener {

    func onPhotoProgress(progress: Float, id: String) {
        model.updateProgress(id: id, progress: progress)
        _ = model.getProgress()
        updateProgressView()
    }
}
