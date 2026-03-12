import Foundation

enum PlacesListViewState: Equatable {
    case loading
    case content(items: [Place])
    case error(message: String)
}
