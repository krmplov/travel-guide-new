import Foundation

struct LoginRequest: Equatable {
    let login: String
    let password: String

    init(login: String, password: String) {
        self.login = login
        self.password = password
    }
}
