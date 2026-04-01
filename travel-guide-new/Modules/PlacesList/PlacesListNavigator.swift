import UIKit

protocol PlacesListNavigator: AnyObject {
    func openPlaceDetails(placeId: Int)
}

final class PlacesListNavigatorImpl: PlacesListNavigator {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func openPlaceDetails(placeId: Int) {
    }
}
