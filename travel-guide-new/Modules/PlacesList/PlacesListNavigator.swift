import Foundation

protocol PlacesListNavigator: AnyObject {
    func openPlaceDetails(placeId: UUID)
    func openAuth()
}
