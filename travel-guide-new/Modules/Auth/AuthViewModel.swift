import Foundation

protocol AuthViewModel {
    var onStateChange: ((AuthViewState) -> Void)? { get set }

    func didLoad()
    func didTapLogin(login: String, password: String)
}

final class AuthViewModelImpl: AuthViewModel {
    var onStateChange: ((AuthViewState) -> Void)?

    private let authService: AuthService
    private let navigator: AuthNavigator

    init(authService: AuthService, navigator: AuthNavigator) {
        self.authService = authService
        self.navigator = navigator
    }

    func didLoad() {
        onStateChange?(.form)
    }

    func didTapLogin(login: String, password: String) {
        if login.isEmpty || password.isEmpty {
            onStateChange?(.error(message: "Введите логин и пароль"))
            return
        }

        onStateChange?(.loading)

        Task {
            do {
                let request = LoginRequest(login: login, password: password)
                _ = try await authService.login(loginRequest: request)

                await MainActor.run {
                    self.navigator.openPlacesList()
                }
            } catch let error as DomainError {
                await MainActor.run {
                    switch error {
                    case .unauthorized(let message):
                        self.onStateChange?(.error(message: message))
                    default:
                        self.onStateChange?(.error(message: "Ошибка входа"))
                    }
                }
            } catch {
                await MainActor.run {
                    self.onStateChange?(.error(message: "Ошибка входа"))
                }
            }
        }
    }
}
