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
    func didPullToRefresh()
    func didChangeSearchQuery(_ query: String)
    func didSelectPlace(id: Int)
}

final class PlacesListViewModelImpl: PlacesListViewModel {
    var onStateChange: ((PlacesListViewState) -> Void)?
    var onOutput: ((PlacesListOutput) -> Void)?

    private let placesService: PlacesService
    private let navigator: PlacesListNavigator
    private var allItems: [PlaceCellViewModel] = []
    private var currentSearchQuery = ""

    init(
        placesService: PlacesService,
        navigator: PlacesListNavigator
    ) {
        self.placesService = placesService
        self.navigator = navigator
    }

    func didLoad() {
        loadPlaces(isRefreshing: false)
    }

    func didPullToRefresh() {
        loadPlaces(isRefreshing: true)
    }

    func didChangeSearchQuery(_ query: String) {
        currentSearchQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        publishFilteredItems()
    }

    func didSelectPlace(id: Int) {
        onOutput?(.didSelectPlace(placeId: id))
        navigator.openPlaceDetails(placeId: id)
    }

    private func loadPlaces(isRefreshing: Bool) {
        onStateChange?(.loading(isRefreshing: isRefreshing))

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
                    self.allItems = items
                    self.publishFilteredItems()
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

    private func publishFilteredItems() {
        let items: [PlaceCellViewModel]

        if currentSearchQuery.isEmpty {
            items = allItems
        } else {
            let normalizedQuery = currentSearchQuery.localizedLowercase

            items = allItems.filter { item in
                item.title.localizedLowercase.contains(normalizedQuery)
                || (item.subtitle?.localizedLowercase.contains(normalizedQuery) ?? false)
            }
        }

        if items.isEmpty {
            let isSearchActive = currentSearchQuery.isEmpty == false
            let message = isSearchActive ? "Ничего не найдено" : "Список пуст"
            onStateChange?(.empty(message: message, showsInlineInList: isSearchActive))
        } else {
            onStateChange?(.content(items: items))
        }
    }
}
