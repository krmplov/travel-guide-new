import Foundation

protocol PlacesService {
    func fetchPlaces() async throws -> [Place]
    func fetchPlaceDetails(placeId: Int) async throws -> PlaceDetails
}

final class PlacesServiceImpl: PlacesService {
    private let repository: PlacesRepository

    init(repository: PlacesRepository) {
        self.repository = repository
    }

    func fetchPlaces() async throws -> [Place] {
        try await repository.fetchPlaces()
    }

    func fetchPlaceDetails(placeId: Int) async throws -> PlaceDetails {
        try await repository.fetchPlaceDetails(placeId: placeId)
    }
}
