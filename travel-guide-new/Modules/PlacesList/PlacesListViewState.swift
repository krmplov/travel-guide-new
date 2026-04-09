import Foundation

enum PlacesListViewState: Equatable {
    case loading
    case content(items: [PlaceCellViewModel])
    case empty
    case error(message: String)
}
