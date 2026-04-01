import Foundation

struct PlacesResponseDTO: Decodable {
    let results: [PlaceDTO]
}

struct PlaceDTO: Decodable {
    let id: Int
    let title: String
    let address: String?
    let images: [PlaceImageDTO]?

    var subtitle: String? {
        address
    }

    var imageURL: URL? {
        images?.first?.url
    }
}

struct PlaceDetailsDTO: Decodable {
    let id: Int
    let title: String
    let address: String?
    let description: String?
    let images: [PlaceImageDTO]?
}

struct PlaceImageDTO: Decodable {
    let image: String

    var url: URL? {
        URL(string: image)
    }
}
