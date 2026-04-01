import Foundation

struct PlaceDetailsInput: Equatable {
    let placeId: Int
}

enum PlaceDetailsOutput: Equatable {
    case didClose
    case didToggleFavorite(placeId: Int, isFavorite: Bool)
}

protocol PlaceDetailsViewModel {
    var onStateChange: ((PlaceDetailsViewState) -> Void)? { get set }
    var onOutput: ((PlaceDetailsOutput) -> Void)? { get set }

    func didLoad()
    func didTapToggleFavorite()
    func didTapClose()
}
