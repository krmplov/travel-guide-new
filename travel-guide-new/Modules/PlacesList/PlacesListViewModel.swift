import Foundation

struct PlacesListInput: Equatable {
    let openedAfterLogin: Bool
}

enum PlacesListOutput: Equatable {
    case didSelectPlace(placeId: UUID)
    case didLogout
}

protocol PlacesListViewModel {
    var onStateChange: ((PlacesListViewState) -> Void)? { get set }
    var onOutput: ((PlacesListOutput) -> Void)? { get set }

    func didLoad()
    func didSelectPlace(id: UUID)
    func didTapLogout()
}
