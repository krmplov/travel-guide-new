import UIKit

final class DSError: UIView {
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private lazy var retryButton: DSButton = {
        let button = DSButton(style: .primary)
        button.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        return button
    }()

    var onRetry: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = DS.Color.background
        translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = DS.Space.space200
        stackView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.apply(.body)
        titleLabel.textColor = DS.Color.danger
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(retryButton)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Space.space300),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Space.space300)
        ])
    }

    func configure(message: String, retryTitle: String) {
        titleLabel.text = message
        retryButton.setTitle(retryTitle, for: .normal)
    }

    @objc private func didTapRetry() {
        onRetry?()
    }
}
