import Foundation

protocol FavoriteService {
    func toggleFavorite(placeId: Int) async throws -> FavoriteStatus
}
