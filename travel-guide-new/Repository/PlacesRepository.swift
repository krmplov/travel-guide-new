import Foundation

protocol PlacesRepository {
    func fetchPlaces() async throws -> [Place]
    func fetchPlaceDetails(placeId: Int) async throws -> PlaceDetails
}

final class PlacesRepositoryImpl: PlacesRepository {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = URLSessionNetworkClient()) {
        self.networkClient = networkClient
    }

    func fetchPlaces() async throws -> [Place] {
        guard let url = PlacesAPI.placesListURL() else {
            throw DomainError.unknown(message: "Некорректный URL")
        }

        let response: PlacesResponseDTO = try await networkClient.get(url)

        return response.results.map { placeDTO in
            Place(
                id: placeDTO.id,
                title: placeDTO.title,
                description: placeDTO.subtitle,
                imageURL: placeDTO.imageURL
            )
        }
    }

    func fetchPlaceDetails(placeId: Int) async throws -> PlaceDetails {
        guard let url = PlacesAPI.placeDetailsURL(placeId: placeId) else {
            throw DomainError.unknown(message: "Некорректный URL")
        }

        let dto: PlaceDetailsDTO = try await networkClient.get(url)

        return PlaceDetails(
            id: dto.id,
            title: dto.title,
            description: dto.description,
            address: dto.address ?? "Адрес не указан",
            imageURLs: dto.images?.compactMap(\.url) ?? []
        )
    }
}
