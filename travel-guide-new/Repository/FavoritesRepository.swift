import Foundation

protocol FavoritesRepository {
    func isFavorite(placeId: UUID) -> Bool
    func toggleFavorite(placeId: UUID) async throws -> FavoriteStatus
}
