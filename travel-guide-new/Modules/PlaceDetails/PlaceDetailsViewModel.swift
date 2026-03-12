import Foundation

struct PlaceDetailsInput: Equatable {
    let placeId: UUID
}

enum PlaceDetailsOutput: Equatable {
    case didClose
    case didToggleFavorite(placeId: UUID, isFavorite: Bool)
}

protocol PlaceDetailsViewModel {
    var onStateChange: ((PlaceDetailsViewState) -> Void)? { get set }
    var onOutput: ((PlaceDetailsOutput) -> Void)? { get set }

    func didLoad()
    func didTapToggleFavorite()
    func didTapClose()
}
