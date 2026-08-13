import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

struct APIRequest {
    let method: HTTPMethod
    let path: String
    var queryItems: [URLQueryItem] = []
    var body: Data?
    var requiresAuth: Bool = false
    var additionalHeaders: [String: String] = [:]

    static func get(_ path: String, query: [URLQueryItem] = [], auth: Bool = false) -> APIRequest {
        APIRequest(method: .get, path: path, queryItems: query, requiresAuth: auth)
    }

    static func post(_ path: String, body: Encodable?, auth: Bool = false) -> APIRequest {
        var request = APIRequest(method: .post, path: path, requiresAuth: auth)
        if let body {
            request.body = try? JSONEncoder.api.encode(body)
        }
        return request
    }

    static func postJSON(_ path: String, json: [String: Any], auth: Bool = false) -> APIRequest {
        var request = APIRequest(method: .post, path: path, requiresAuth: auth)
        request.body = try? JSONSerialization.data(withJSONObject: json)
        return request
    }
}

extension JSONEncoder {
    static let api: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        return encoder
    }()
}

extension JSONDecoder {
    static let api: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }()
}
