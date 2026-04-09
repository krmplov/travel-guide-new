import UIKit

protocol AuthView: AnyObject {
    func update(_ state: AuthViewState)
}

final class AuthViewController: UIViewController, AuthView {
    private var viewModel: AuthViewModel

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let contentStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let loginTextField = DSTextField(
        configuration: .init(
            title: "Логин",
            placeholder: "Введите логин"
        )
    )
    private let passwordTextField = DSTextField(
        configuration: .init(
            title: "Пароль",
            placeholder: "Введите пароль",
            isSecureTextEntry: true
        )
    )
    private let errorLabel = UILabel()
    private let loginButton = DSButton(style: .primary)

    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardObservers()

        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.update(state)
            }
        }

        viewModel.didLoad()
    }

    private func setupUI() {
        view.backgroundColor = DS.Color.background

        setupViews()
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupViews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = DS.Space.space200

        titleLabel.apply(.headingXL)
        titleLabel.text = "Вход"
        titleLabel.numberOfLines = 0

        subtitleLabel.apply(.body)
        subtitleLabel.text = "Войдите, чтобы посмотреть список мест"
        subtitleLabel.textColor = DS.Color.textSubtle
        subtitleLabel.numberOfLines = 0

        errorLabel.apply(.error)
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        loginButton.setTitle("Войти", for: .normal)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }

    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentStackView)

        [titleLabel, subtitleLabel, loginTextField, passwordTextField, errorLabel, loginButton].forEach {
            contentStackView.addArrangedSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DS.Space.space400 * 2),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Space.space300),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Space.space300),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DS.Space.space300)
        ])
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    @objc
    private func keyboardWillChangeFrame(_ note: Notification) {
        guard
            let userInfo = note.userInfo,
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        let keyboardInView = view.convert(endFrame, from: nil)
        let intersection = view.bounds.intersection(keyboardInView)

        scrollView.contentInset.bottom = intersection.height
        scrollView.verticalScrollIndicatorInsets.bottom = intersection.height
    }

    @objc
    private func didTapLogin() {
        viewModel.didTapLogin(
            login: loginTextField.text,
            password: passwordTextField.text
        )
    }

    func update(_ state: AuthViewState) {
        switch state {
        case .form:
            setFormEnabled(true)
            loginButton.setTitle("Войти", for: .normal)
            errorLabel.isHidden = true

        case .loading:
            setFormEnabled(false)
            loginButton.setTitle("Входим...", for: .normal)
            errorLabel.isHidden = true

        case .error(let message):
            setFormEnabled(true)
            loginButton.setTitle("Войти", for: .normal)
            errorLabel.text = message
            errorLabel.isHidden = false
        }
    }

    private func setFormEnabled(_ isEnabled: Bool) {
        loginTextField.setEnabled(isEnabled)
        passwordTextField.setEnabled(isEnabled)
        loginButton.isEnabled = isEnabled
    }
}
