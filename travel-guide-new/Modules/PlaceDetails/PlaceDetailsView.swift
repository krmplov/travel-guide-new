import UIKit

protocol PlaceDetailsView: AnyObject {
    func update(_ state: PlaceDetailsViewState)
}

final class PlaceDetailsViewController: UIViewController, PlaceDetailsView {
    private let placeId: Int

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    init(placeId: Int) {
        self.placeId = placeId
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Детали"

        setupUI()
    }

    private func setupUI() {
        view.addSubview(titleLabel)

        titleLabel.text = "Экран деталей места"

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
        ])
    }

    func update(_ state: PlaceDetailsViewState) {
    }
}
