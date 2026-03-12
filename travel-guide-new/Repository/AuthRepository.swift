import Foundation

protocol AuthRepository {
    func login(loginRequest: LoginRequest) async throws -> UserSession
}

struct InMemoryCredentials: Equatable {
    let login: String
    let password: String
}

final class AuthRepositoryImpl: AuthRepository {
    private let credentials: InMemoryCredentials

    init(credentials: InMemoryCredentials = InMemoryCredentials(login: "polina", password: "1234")) {
        self.credentials = credentials
    }
    
    func login(loginRequest: LoginRequest) async throws -> UserSession {
        guard loginRequest.login == credentials.login,
                loginRequest.password == credentials.password else {
            throw DomainError.unauthorized(message: "Неверный логин или пароль")
        }

        return UserSession(
            token: UUID().uuidString,
            userId: credentials.login
        )
    }
}
