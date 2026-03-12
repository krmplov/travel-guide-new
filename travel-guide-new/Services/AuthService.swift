import Foundation

protocol AuthService {
    func login(loginRequest: LoginRequest) async throws -> UserSession
}

final class AuthServiceImpl: AuthService {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func login(loginRequest: LoginRequest) async throws -> UserSession {
        try await repository.login(loginRequest: loginRequest)
    }
}
