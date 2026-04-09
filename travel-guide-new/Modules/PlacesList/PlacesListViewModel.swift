import Foundation

struct PlacesListInput: Equatable {
    let openedAfterLogin: Bool
}

enum PlacesListOutput: Equatable {
    case didSelectPlace(placeId: Int)
}

protocol PlacesListViewModel {
    var onStateChange: ((PlacesListViewState) -> Void)? { get set }
    var onOutput: ((PlacesListOutput) -> Void)? { get set }

    func didLoad()
    func didSelectPlace(id: Int)
}

final class PlacesListViewModelImpl: PlacesListViewModel {
    var onStateChange: ((PlacesListViewState) -> Void)?
    var onOutput: ((PlacesListOutput) -> Void)?

    private let placesService: PlacesService
    private let navigator: PlacesListNavigator

    init(
        placesService: PlacesService,
        navigator: PlacesListNavigator
    ) {
        self.placesService = placesService
        self.navigator = navigator
    }

    func didLoad() {
        onStateChange?(.loading)

        Task {
            do {
                let places = try await placesService.fetchPlaces()

                let items = places.map {
                    PlaceCellViewModel(
                        id: $0.id,
                        title: $0.title,
                        subtitle: $0.description,
                        imageURL: $0.imageURL
                    )
                }

                await MainActor.run {
                    if items.isEmpty {
                        self.onStateChange?(.empty)
                    } else {
                        self.onStateChange?(.content(items: items))
                    }
                }
            } catch let error as DomainError {
                await MainActor.run {
                    switch error {
                    case .network:
                        self.onStateChange?(.error(message: "Ошибка сети"))
                    case .httpStatus(let code):
                        self.onStateChange?(.error(message: "Ошибка сервера: \(code)"))
                    case .decoding:
                        self.onStateChange?(.error(message: "Не удалось обработать данные"))
                    case .unknown(let message):
                        self.onStateChange?(.error(message: message))
                    default:
                        self.onStateChange?(.error(message: "Не удалось загрузить список"))
                    }
                }
            } catch {
                await MainActor.run {
                    self.onStateChange?(.error(message: "Не удалось загрузить список"))
                }
            }
        }
    }

    func didSelectPlace(id: Int) {
        onOutput?(.didSelectPlace(placeId: id))
        navigator.openPlaceDetails(placeId: id)
    }
}
