import Foundation

enum PlacesListViewState: Equatable {
    case loading(isRefreshing: Bool)
    case content(items: [PlaceCellViewModel])
    case empty(message: String, showsInlineInList: Bool)
    case error(message: String)
}
