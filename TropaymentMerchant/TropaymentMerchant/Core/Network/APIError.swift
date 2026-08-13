import Foundation

enum APIError: LocalizedError, Equatable {
    case invalidURL
    case noData
    case decodingFailed(String)
    case network(ErrorDescription)
    case timeout
    case unauthorized
    case forbidden(message: String, kycRequired: Bool)
    case validation(message: String, fieldErrors: [String: [String]], requiresCaptcha: Bool)
    case rateLimited(retryAfter: Int?)
    case maintenance(message: String)
    case serverError(statusCode: Int, message: String)
    case unknown(statusCode: Int, message: String)

    struct ErrorDescription: Equatable {
        let message: String
    }

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return String(localized: "error.invalid_url")
        case .noData:
            return String(localized: "error.no_data")
        case .decodingFailed:
            return String(localized: "error.decoding_failed")
        case .network(let info):
            return info.message
        case .timeout:
            return String(localized: "error.timeout")
        case .unauthorized:
            return String(localized: "error.unauthorized")
        case .forbidden(let message, _):
            return message
        case .validation(let message, _, _):
            return message
        case .rateLimited:
            return String(localized: "error.rate_limited")
        case .maintenance(let message):
            return message
        case .serverError(_, let message):
            return message
        case .unknown(_, let message):
            return message
        }
    }

    var fieldErrors: [String: [String]] {
        if case .validation(_, let errors, _) = self { return errors }
        return [:]
    }

    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL), (.noData, .noData), (.timeout, .timeout), (.unauthorized, .unauthorized):
            return true
        case (.decodingFailed(let a), .decodingFailed(let b)):
            return a == b
        case (.network(let a), .network(let b)):
            return a == b
        case (.forbidden(let m1, let k1), .forbidden(let m2, let k2)):
            return m1 == m2 && k1 == k2
        case (.validation(let m1, let e1, let c1), .validation(let m2, let e2, let c2)):
            return m1 == m2 && e1 == e2 && c1 == c2
        case (.rateLimited(let a), .rateLimited(let b)):
            return a == b
        case (.maintenance(let a), .maintenance(let b)):
            return a == b
        case (.serverError(let c1, let m1), .serverError(let c2, let m2)):
            return c1 == c2 && m1 == m2
        case (.unknown(let c1, let m1), .unknown(let c2, let m2)):
            return c1 == c2 && m1 == m2
        default:
            return false
        }
    }

    var isUnauthorized: Bool {
        if case .unauthorized = self { return true }
        return false
    }

    static func from(data: Data?, response: HTTPURLResponse?) -> APIError {
        let statusCode = response?.statusCode ?? 0
        let payload = decodePayload(from: data)

        switch statusCode {
        case 401:
            return .unauthorized
        case 403:
            let kyc = payload?["kyc_required"] as? Bool ?? false
            let message = payload?["message"] as? String ?? String(localized: "error.forbidden")
            return .forbidden(message: message, kycRequired: kyc)
        case 422:
            let message = payload?["message"] as? String ?? String(localized: "error.validation")
            let errors = parseFieldErrors(from: payload)
            let requiresCaptcha = payload?["requires_captcha"] as? Bool ?? false
            return .validation(message: message, fieldErrors: errors, requiresCaptcha: requiresCaptcha)
        case 429:
            let retry = payload?["retry_after"] as? Int
            return .rateLimited(retryAfter: retry)
        case 503 where payload?["maintenance"] as? Bool == true:
            let message = payload?["message"] as? String ?? String(localized: "error.maintenance")
            return .maintenance(message: message)
        case 500...599:
            let message = payload?["message"] as? String ?? String(localized: "error.server")
            return .serverError(statusCode: statusCode, message: message)
        default:
            let message = payload?["message"] as? String ?? String(localized: "error.unknown")
            return .unknown(statusCode: statusCode, message: message)
        }
    }

    private static func decodePayload(from data: Data?) -> [String: Any]? {
        guard let data, !data.isEmpty else { return nil }
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    }

    private static func parseFieldErrors(from payload: [String: Any]?) -> [String: [String]] {
        guard let errors = payload?["errors"] as? [String: Any] else { return [:] }
        var result: [String: [String]] = [:]
        for (key, value) in errors {
            if let messages = value as? [String] {
                result[key] = messages
            } else if let message = value as? String {
                result[key] = [message]
            }
        }
        return result
    }
}
