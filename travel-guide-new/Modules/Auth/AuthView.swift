import UIKit

protocol AuthView: AnyObject {
    func update(_ state: AuthViewState)
}

final class AuthViewController: UIViewController, AuthView {
    private var viewModel: AuthViewModel

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let loginTextField = UITextField()
    private let passwordTextField = UITextField()
    private let errorLabel = UILabel()
    private let loginButton = UIButton(type: .system)

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
        view.backgroundColor = .white

        setupViews()
        setupHierarchy()
        setupConstraints()
    }

    private func setupViews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        loginTextField.placeholder = "Логин"
        loginTextField.borderStyle = .roundedRect
        loginTextField.translatesAutoresizingMaskIntoConstraints = false

        passwordTextField.placeholder = "Пароль"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false

        errorLabel.textColor = .red
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        loginButton.setTitle("Войти", for: .normal)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        [loginTextField, passwordTextField, errorLabel, loginButton].forEach {
            contentView.addSubview($0)
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

            loginTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            loginTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            loginTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 12),
            passwordTextField.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),

            errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12),
            errorLabel.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),

            loginButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
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
            login: loginTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }

    func update(_ state: AuthViewState) {
        switch state {
        case .form:
            loginButton.isEnabled = true
            errorLabel.isHidden = true

        case .loading:
            loginButton.isEnabled = false
            errorLabel.isHidden = true

        case .error(let message):
            loginButton.isEnabled = true
            errorLabel.text = message
            errorLabel.isHidden = false
        }
    }
}
