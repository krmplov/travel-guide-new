import Foundation

struct Place: Equatable, Identifiable, Codable {
    let id: Int
    let title: String
    let description: String?
    let imageURL: URL?

    init(
        id: Int,
        title: String,
        description: String? = nil,
        imageURL: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageURL = imageURL
    }
}
