import Foundation

struct PlaceDetailsViewData: Equatable {
    let id: UUID
    let title: String
    let description: String?
    let address: String
    let imageURLs: [URL]
    let isFavorite: Bool
}

enum PlaceDetailsViewState: Equatable {
    case loading
    case content(PlaceDetailsViewData)
    case error(message: String)
}
