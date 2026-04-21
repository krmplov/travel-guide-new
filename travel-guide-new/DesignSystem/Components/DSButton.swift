import UIKit

final class DSButton: UIButton {
    enum Style {
        case primary
        case subtle
        case danger
    }

    private let style: Style

    init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        setupView()
        applyStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = DS.Typography.button
        layer.cornerRadius = DS.Radius.medium
        clipsToBounds = true

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: DS.Size.buttonHeight)
        ])
    }

    private func applyStyle() {
        layer.borderWidth = 0
        layer.borderColor = nil

        switch style {
        case .primary:
            backgroundColor = DS.Color.brand
            setTitleColor(DS.Color.textInverse, for: .normal)

        case .subtle:
            backgroundColor = DS.Color.transparent
            setTitleColor(DS.Color.brand, for: .normal)
            layer.borderWidth = DS.BorderWidth.standard
            layer.borderColor = DS.Color.border.cgColor

        case .danger:
            backgroundColor = DS.Color.danger
            setTitleColor(DS.Color.textInverse, for: .normal)
        }
    }

    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                applyStyle()
            } else {
                backgroundColor = DS.Color.disabledBackground
                setTitleColor(DS.Color.disabledText, for: .normal)
                layer.borderWidth = 0
                layer.borderColor = nil
            }
        }
    }

    override var isHighlighted: Bool {
        didSet {
            guard isEnabled else { return }

            switch style {
            case .primary:
                backgroundColor = isHighlighted ? DS.Color.brandPressed : DS.Color.brand
            case .subtle:
                backgroundColor = isHighlighted ? DS.Color.surface : DS.Color.transparent
            case .danger:
                backgroundColor = isHighlighted ? DS.Color.dangerPressed : DS.Color.danger
            }
        }
    }
}
