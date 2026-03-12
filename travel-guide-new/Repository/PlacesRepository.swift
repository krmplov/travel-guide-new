import Foundation

protocol PlacesRepository {
    func fetchPlaces() async throws -> [Place]
    func fetchPlaceDetails(placeId: UUID) async throws -> PlaceDetails
}
