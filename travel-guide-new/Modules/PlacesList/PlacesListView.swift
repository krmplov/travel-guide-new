import UIKit

protocol PlacesListView: AnyObject {
    func update(_ state: PlacesListViewState)
}

final class PlacesListViewController: UIViewController, PlacesListView {
    private var viewModel: PlacesListViewModel

    private let statusLabel = UILabel()

    init(viewModel: PlacesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Места"

        setupUI()

        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.update(state)
            }
        }

        viewModel.didLoad()
    }

    private func setupUI() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        statusLabel.text = "Загрузка..."

        view.addSubview(statusLabel)

        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func update(_ state: PlacesListViewState) {
        switch state {
        case .loading:
            statusLabel.text = "Загрузка..."

        case .content(let items):
            let titles = items.prefix(5).map(\.title).joined(separator: "\n")
            statusLabel.text = "Загружено: \(items.count)\n\n\(titles)"

        case .empty:
            statusLabel.text = "Список пуст"

        case .error(let message):
            statusLabel.text = "Ошибка:\n\(message)"
        }
    }
}
