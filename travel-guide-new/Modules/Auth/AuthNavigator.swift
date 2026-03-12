import UIKit

protocol AuthNavigator: AnyObject {
    func openPlacesList()
}

final class AuthNavigatorImpl: AuthNavigator {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func openPlacesList() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemBackground
        viewController.title = "Места"

        navigationController?.setViewControllers([viewController], animated: true)
    }

}
