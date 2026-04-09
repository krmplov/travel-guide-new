import UIKit

final class DSTextField: UIView {
    struct Configuration {
        let title: String?
        let placeholder: String
        let text: String?
        let errorText: String?
        let isEnabled: Bool
        let isSecureTextEntry: Bool
        let keyboardType: UIKeyboardType
        let autocapitalizationType: UITextAutocapitalizationType
        let autocorrectionType: UITextAutocorrectionType

        init(
            title: String? = nil,
            placeholder: String,
            text: String? = nil,
            errorText: String? = nil,
            isEnabled: Bool = true,
            isSecureTextEntry: Bool = false,
            keyboardType: UIKeyboardType = .default,
            autocapitalizationType: UITextAutocapitalizationType = .none,
            autocorrectionType: UITextAutocorrectionType = .no
        ) {
            self.title = title
            self.placeholder = placeholder
            self.text = text
            self.errorText = errorText
            self.isEnabled = isEnabled
            self.isSecureTextEntry = isSecureTextEntry
            self.keyboardType = keyboardType
            self.autocapitalizationType = autocapitalizationType
            self.autocorrectionType = autocorrectionType
        }
    }

    private let stackView = UIStackView()
    private let label = UILabel()
    private let textField = UITextField()
    private let messageLabel = UILabel()
    private var currentConfiguration: Configuration?

    var text: String {
        textField.text ?? ""
    }

    init(configuration: Configuration) {
        super.init(frame: .zero)
        setupView()
        configure(with: configuration)
    }

    convenience init(labelText: String? = nil, placeholder: String) {
        self.init(configuration: Configuration(title: labelText, placeholder: placeholder))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = DS.Space.space050
        stackView.translatesAutoresizingMaskIntoConstraints = false

        label.apply(.caption)

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = DS.Typography.body
        textField.textColor = DS.Color.text
        textField.backgroundColor = DS.Color.surface
        textField.layer.cornerRadius = DS.Radius.medium
        textField.layer.borderWidth = DS.BorderWidth.standard
        textField.layer.borderColor = DS.Color.border.cgColor
        textField.clearButtonMode = .whileEditing

        let inset = UIView(frame: CGRect(x: 0, y: 0, width: DS.Space.space200, height: 1))
        textField.leftView = inset
        textField.leftViewMode = .always

        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: DS.Size.textFieldHeight)
        ])

        messageLabel.apply(.error)
        messageLabel.numberOfLines = 0
        messageLabel.isHidden = true

        addSubview(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(messageLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(with configuration: Configuration) {
        currentConfiguration = configuration

        label.text = configuration.title
        label.isHidden = configuration.title?.isEmpty ?? true

        textField.placeholder = configuration.placeholder
        textField.text = configuration.text
        textField.isSecureTextEntry = configuration.isSecureTextEntry
        textField.keyboardType = configuration.keyboardType
        textField.autocapitalizationType = configuration.autocapitalizationType
        textField.autocorrectionType = configuration.autocorrectionType

        setEnabled(configuration.isEnabled)
        setError(configuration.errorText)
    }

    func configure(labelText: String?, placeholder: String) {
        configure(with: Configuration(title: labelText, placeholder: placeholder))
    }

    func setError(_ text: String?) {
        let hasError = !(text?.isEmpty ?? true)
        messageLabel.text = text
        messageLabel.isHidden = !hasError
        textField.layer.borderColor = hasError ? DS.Color.danger.cgColor : DS.Color.border.cgColor
        currentConfiguration = Configuration(
            title: currentConfiguration?.title,
            placeholder: currentConfiguration?.placeholder ?? textField.placeholder ?? "",
            text: textField.text,
            errorText: text,
            isEnabled: textField.isEnabled,
            isSecureTextEntry: textField.isSecureTextEntry,
            keyboardType: textField.keyboardType,
            autocapitalizationType: textField.autocapitalizationType,
            autocorrectionType: textField.autocorrectionType
        )
    }

    func setSecureEntry(_ value: Bool) {
        textField.isSecureTextEntry = value
        currentConfiguration = Configuration(
            title: currentConfiguration?.title,
            placeholder: currentConfiguration?.placeholder ?? textField.placeholder ?? "",
            text: textField.text,
            errorText: currentConfiguration?.errorText,
            isEnabled: textField.isEnabled,
            isSecureTextEntry: value,
            keyboardType: textField.keyboardType,
            autocapitalizationType: textField.autocapitalizationType,
            autocorrectionType: textField.autocorrectionType
        )
    }

    func setEnabled(_ value: Bool) {
        textField.isEnabled = value
        textField.backgroundColor = value ? DS.Color.surface : DS.Color.disabledBackground
        textField.textColor = value ? DS.Color.text : DS.Color.disabledText
        currentConfiguration = Configuration(
            title: currentConfiguration?.title,
            placeholder: currentConfiguration?.placeholder ?? textField.placeholder ?? "",
            text: textField.text,
            errorText: currentConfiguration?.errorText,
            isEnabled: value,
            isSecureTextEntry: textField.isSecureTextEntry,
            keyboardType: textField.keyboardType,
            autocapitalizationType: textField.autocapitalizationType,
            autocorrectionType: textField.autocorrectionType
        )
    }

    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        textField.addTarget(target, action: action, for: controlEvents)
    }
}
