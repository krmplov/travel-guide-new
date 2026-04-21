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

final class PlaceDetailsViewModelImpl: PlaceDetailsViewModel {
    var onStateChange: ((PlaceDetailsViewState) -> Void)?
    var onOutput: ((PlaceDetailsOutput) -> Void)?

    private let input: PlaceDetailsInput
    private let placesService: PlacesService
    private let navigator: PlaceDetailsNavigator
    private var currentViewData: PlaceDetailsViewData?

    init(
        input: PlaceDetailsInput,
        placesService: PlacesService,
        navigator: PlaceDetailsNavigator
    ) {
        self.input = input
        self.placesService = placesService
        self.navigator = navigator
    }

    func didLoad() {
        onStateChange?(.loading)

        Task {
            do {
                let placeDetails = try await placesService.fetchPlaceDetails(placeId: input.placeId)
                let viewData = PlaceDetailsViewData(
                    id: placeDetails.id,
                    title: placeDetails.title,
                    description: placeDetails.description,
                    address: placeDetails.address,
                    imageURLs: placeDetails.imageURLs,
                    isFavorite: currentViewData?.isFavorite ?? false
                )

                await MainActor.run {
                    self.currentViewData = viewData
                    self.onStateChange?(.content(viewData))
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
                    case .notFound:
                        self.onStateChange?(.error(message: "Место не найдено"))
                    case .unknown(let message):
                        self.onStateChange?(.error(message: message))
                    default:
                        self.onStateChange?(.error(message: "Не удалось загрузить детали"))
                    }
                }
            } catch {
                await MainActor.run {
                    self.onStateChange?(.error(message: "Не удалось загрузить детали"))
                }
            }
        }
    }

    func didTapToggleFavorite() {
        guard var currentViewData else { return }

        currentViewData = PlaceDetailsViewData(
            id: currentViewData.id,
            title: currentViewData.title,
            description: currentViewData.description,
            address: currentViewData.address,
            imageURLs: currentViewData.imageURLs,
            isFavorite: currentViewData.isFavorite == false
        )

        self.currentViewData = currentViewData
        onStateChange?(.content(currentViewData))
        onOutput?(.didToggleFavorite(placeId: currentViewData.id, isFavorite: currentViewData.isFavorite))
    }

    func didTapClose() {
        onOutput?(.didClose)
        navigator.close()
    }
}
