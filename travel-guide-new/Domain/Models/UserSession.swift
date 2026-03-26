import Foundation

struct UserSession: Equatable {
    let token: String
    let userId: String
    
    init(token: String, userId: String) {
        self.token = token
        self.userId = userId
    }
}
