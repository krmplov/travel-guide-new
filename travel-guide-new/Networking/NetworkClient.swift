import Foundation

protocol NetworkClient {
    func get<T: Decodable>(_ url: URL) async throws -> T
}

final class URLSessionNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }

    func get<T: Decodable>(_ url: URL) async throws -> T {
        do {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw DomainError.network
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                throw DomainError.httpStatus(code: httpResponse.statusCode)
            }

            do {
                return try decoder.decode(T.self, from: data)
            } catch is DecodingError {
                throw DomainError.decoding
            } catch {
                throw DomainError.unknown(message: "Не удалось прочитать ответ сервера")
            }
        } catch let error as DomainError {
            throw error
        } catch is URLError {
            throw DomainError.network
        } catch {
            throw DomainError.unknown(message: error.localizedDescription)
        }
    }
}
