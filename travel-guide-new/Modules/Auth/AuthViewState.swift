import Foundation

enum AuthViewState: Equatable {
    case form
    case loading
    case error(message: String)
}
