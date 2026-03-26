import Foundation

protocol FavoriteService {
    func toggleFavorite(placeId: UUID) async throws -> FavoriteStatus
}
