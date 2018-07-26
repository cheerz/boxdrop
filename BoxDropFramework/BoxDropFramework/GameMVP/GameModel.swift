import AVFoundation

class GameModel {

}

// MARK: - Game.Model
extension GameModel: Game.Model {

    func setProgressListener(with progressListener: GameUploadingProgressListener) {
        fatalError("\(#function) has not been implemented")
    }

    func updateProgress(id: String, progress: Float) {
        fatalError("\(#function) has not been implemented")
    }

    func getProgress() -> Float {
        fatalError("\(#function) has not been implemented")
    }

    func isUploadComplete() -> Bool {
        fatalError("\(#function) has not been implemented")
    }

    func remainingPhotos() -> Int {
        fatalError("\(#function) has not been implemented")
    }

    func getTotalProgress() -> Float {
        fatalError("\(#function) has not been implemented")
    }

    func getVideoPlayer() -> AVPlayer? {
        fatalError("\(#function) has not been implemented")
    }

    func isUploadedOrFailed() -> Bool {
        fatalError("\(#function) has not been implemented")
    }

    func resetUploadIfNeeded() {
        fatalError("\(#function) has not been implemented")
    }

    func getCurrentImage(handler: @escaping (UIImage?) -> ()) {
        fatalError("\(#function) has not been implemented")
    }

    func newImageNeeded() -> Bool {
        fatalError("\(#function) has not been implemented")
    }
}
