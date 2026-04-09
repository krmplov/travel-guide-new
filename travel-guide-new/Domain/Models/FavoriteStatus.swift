import Foundation

struct FavoriteStatus: Equatable {
    let placeId: Int
    let isFavorite: Bool

    init(placeId: Int, isFavorite: Bool) {
        self.placeId = placeId
        self.isFavorite = isFavorite
    }
}
