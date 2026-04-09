import UIKit

final class DSEmpty: UIView {
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

        titleLabel.apply(.body)
        titleLabel.textColor = DS.Color.textSubtle
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Space.space300),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Space.space300)
        ])
    }

    func configure(text: String) {
        titleLabel.text = text
    }
}
