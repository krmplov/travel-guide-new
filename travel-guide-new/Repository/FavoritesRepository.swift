import Foundation

protocol FavoritesRepository {
    func isFavorite(placeId: Int) -> Bool
    func toggleFavorite(placeId: Int) async throws -> FavoriteStatus
}
