import Foundation

class GamePresenter {

    private let model: Game.Model
    private weak var view: Game.View?
    private let navigator: GameUploadingNavigator
    private let action: GameUploadingCompletion?

    let primary = UIColor(red: CGFloat(9.0) / 255, green: CGFloat(77.0) / 255, blue: CGFloat(95.0) / 255, alpha: 1.0)
    let validation = UIColor(red: CGFloat(48) / 255, green: CGFloat(80) / 255, blue: CGFloat(32) / 255, alpha: 1.0)
    
    private enum Text: String {
        case skip = "Skip"
        case done = "Done"
    }

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
        view?.setButton(text: Text.skip.rawValue)
        view?.setProgress(color: primary)
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
        DispatchQueue.main.async {
            self.updateProgressView()
            self.updateText()
            self.updateProgressColor()
        }
    }
    
    private func updateProgressColor() {
        let color = model.isUploadComplete() ? validation : primary
        view?.setProgress(color: color)
    }

    private func updateText() {
        let text = model.isUploadComplete() ? Text.done.rawValue : Text.skip.rawValue
        view?.setButton(text: text)
    }
}
