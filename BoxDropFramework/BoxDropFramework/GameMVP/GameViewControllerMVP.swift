import AVFoundation

enum Game {
    typealias Model = GameUploadingModelProtocol
    typealias View = GameViewProtocol
    typealias Presenter = GamePresenterProtocol
}

public enum GameUploadingCompletion {
    case updateCart
    case removeProduct(Int)
}

public protocol GameUploadingNavigator {

    func showNextView(action: GameUploadingCompletion?)

    func showPreviousView()

}

public protocol GameUploadingProgressListener {

    func onPhotoProgress(progress: Float, id: String)

}

public protocol GameUploadingModelProtocol {

    func setProgressListener(with progressListener: GameUploadingProgressListener)

    func updateProgress(id: String, progress: Float)

    func getProgress() -> Float

    func isUploadComplete() -> Bool

    func remainingPhotos() -> Int

    func getTotalProgress() -> Float

    func getVideoPlayer() -> AVPlayer?

    func isUploadedOrFailed() -> Bool

    func resetUploadIfNeeded()

    func getCurrentImage(handler: @escaping (UIImage?) -> ())

    func newImageNeeded() -> Bool
}

protocol GameViewProtocol: class {

    func updateProgressView(value: Float)

    func updatePreview(image: UIImage)
}

protocol GamePresenterProtocol {

    func onViewDidAppear()

    func onStopButtonTapped()
}
