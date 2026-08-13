import Foundation

@MainActor
final class APIClient {
    static let shared = APIClient()

    private let configuration: AppConfiguration
    private let session: URLSession
    private let keychain: KeychainManager

    var languageCode: String = AppConfiguration.shared.acceptLanguageCode

    private init(
        configuration: AppConfiguration = .shared,
        keychain: KeychainManager = .shared
    ) {
        self.configuration = configuration
        self.keychain = keychain

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = configuration.requestTimeout
        config.timeoutIntervalForResource = configuration.resourceTimeout
        config.waitsForConnectivity = true
        self.session = URLSession(configuration: config)
    }

    func request<T: Decodable>(_ apiRequest: APIRequest, as type: T.Type = T.self) async throws -> T {
        let (data, response) = try await perform(apiRequest)
        guard !data.isEmpty else {
            if T.self == EmptyResponse.self, let empty = EmptyResponse() as? T {
                return empty
            }
            throw APIError.noData
        }
        do {
            return try JSONDecoder.api.decode(T.self, from: data)
        } catch {
            #if DEBUG
            debugLog("Decode error for \(apiRequest.path): \(error.localizedDescription)")
            #endif
            throw APIError.decodingFailed(error.localizedDescription)
        }
    }

    func requestVoid(_ apiRequest: APIRequest) async throws {
        _ = try await perform(apiRequest)
    }

    private func perform(_ apiRequest: APIRequest) async throws -> (Data, HTTPURLResponse) {
        guard var components = URLComponents(
            url: configuration.apiBaseURL.appendingPathComponent(apiRequest.path),
            resolvingAgainstBaseURL: false
        ) else {
            throw APIError.invalidURL
        }

        if !apiRequest.queryItems.isEmpty {
            components.queryItems = apiRequest.queryItems
        }

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = apiRequest.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(languageCode, forHTTPHeaderField: "Accept-Language")
        if apiRequest.requiresAuth, let token = keychain.readAuthToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if apiRequest.body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        for (key, value) in apiRequest.additionalHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }

        request.httpBody = apiRequest.body

        #if DEBUG
        debugLog("\(apiRequest.method.rawValue) \(url.absoluteString)")
        #endif

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.network(.init(message: String(localized: "error.network")))
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let apiError = APIError.from(data: data, response: httpResponse)
                #if DEBUG
                debugLog("HTTP \(httpResponse.statusCode) — \(apiError.localizedDescription)")
                #endif
                if case .unauthorized = apiError {
                    NotificationCenter.default.post(name: .apiUnauthorized, object: nil)
                }
                throw apiError
            }

            return (data, httpResponse)
        } catch let error as APIError {
            throw error
        } catch let urlError as URLError where urlError.code == .timedOut {
            throw APIError.timeout
        } catch {
            throw APIError.network(.init(message: error.localizedDescription))
        }
    }

    #if DEBUG
    private func debugLog(_ message: String) {
        print("[APIClient] \(message)")
    }
    #endif
}

struct EmptyResponse: Decodable, Equatable {
    init() {}
}

extension Notification.Name {
    static let apiUnauthorized = Notification.Name("com.tropayment.apiUnauthorized")
}
