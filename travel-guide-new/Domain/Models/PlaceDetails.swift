import Foundation

struct PlaceDetails: Equatable, Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String?
    let address: String
    let imageURLs: [URL]

    init(
        id: UUID,
        title: String,
        description: String? = nil,
        address: String,
        imageURLs: [URL] = []
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.address = address
        self.imageURLs = imageURLs
    }
}
