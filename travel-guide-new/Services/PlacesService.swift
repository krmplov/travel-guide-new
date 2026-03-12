import Foundation

protocol PlacesService {
    func fetchPlaces() async throws -> [Place]
    func fetchPlaceDetails(placeId: UUID) async throws -> PlaceDetails
}
