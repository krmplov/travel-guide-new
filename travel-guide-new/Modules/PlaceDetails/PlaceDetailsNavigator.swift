import UIKit

protocol PlaceDetailsNavigator: AnyObject {
    func close()
}

final class PlaceDetailsNavigatorImpl: PlaceDetailsNavigator {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func close() {
        navigationController?.popViewController(animated: true)
    }
}
