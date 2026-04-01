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
            guard let navigationController = navigationController else { return }

            let repository = PlacesRepositoryImpl()
            let service = PlacesServiceImpl(repository: repository)
            let navigator = PlacesListNavigatorImpl(navigationController: navigationController)
            let viewModel = PlacesListViewModelImpl(
                placesService: service,
                navigator: navigator
            )
            let viewController = PlacesListViewController(viewModel: viewModel)

            navigationController.setViewControllers([viewController], animated: true)
        }

}
