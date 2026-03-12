import Foundation

struct Place: Equatable, Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String?
    let imageURL: URL?

    init(
        id: UUID,
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
