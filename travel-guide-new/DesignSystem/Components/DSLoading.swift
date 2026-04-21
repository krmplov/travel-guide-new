import UIKit

final class DSLoading: UIView {
    private let stackView = UIStackView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let titleLabel = UILabel()

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
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.apply(.body)
        titleLabel.textColor = DS.Color.textSubtle
        titleLabel.textAlignment = .center

        activityIndicator.startAnimating()

        addSubview(stackView)
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(titleLabel)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: DS.Space.space300),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -DS.Space.space300)
        ])
    }

    func configure(text: String) {
        titleLabel.text = text
    }
}
