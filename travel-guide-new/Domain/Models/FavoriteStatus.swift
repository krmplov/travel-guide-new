import Foundation

struct FavoriteStatus: Equatable {
    let placeId: UUID
    let isFavorite: Bool

    init(placeId: UUID, isFavorite: Bool) {
        self.placeId = placeId
        self.isFavorite = isFavorite
    }
}
