import Foundation

enum PlacesAPI {
    static func placesListURL() -> URL? {
        var components = URLComponents(string: "https://kudago.com/public-api/v1.4/places/")
        components?.queryItems = [
            URLQueryItem(name: "lang", value: "ru"),
            URLQueryItem(name: "location", value: "msk"),
            URLQueryItem(name: "page_size", value: "100"),
            URLQueryItem(name: "fields", value: "id,title,address,description,images")
        ]
        return components?.url
    }

    static func placeDetailsURL(placeId: Int) -> URL? {
        var components = URLComponents(string: "https://kudago.com/public-api/v1.4/places/\(placeId)/")
        components?.queryItems = [
            URLQueryItem(name: "lang", value: "ru"),
            URLQueryItem(name: "fields", value: "id,title,address,description,images")
        ]
        return components?.url
    }
}
