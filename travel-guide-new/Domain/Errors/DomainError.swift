import Foundation

public enum DomainError: Error, Equatable {
    case network
    case httpStatus(code: Int)
    case decoding
    case unauthorized(message: String)
    case notFound
    case validation(message: String)
    case unknown(message: String)
}
