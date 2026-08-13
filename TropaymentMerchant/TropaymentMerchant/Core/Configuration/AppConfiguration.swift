import Foundation

enum AppEnvironment: String, CaseIterable {
    case development
    case staging
    case production

    static var current: AppEnvironment {
        #if DEBUG
        if let raw = ProcessInfo.processInfo.environment["TROPAYMENT_ENV"],
           let env = AppEnvironment(rawValue: raw.lowercased()) {
            return env
        }
        return .development
        #else
        return .production
        #endif
    }
}

struct AppConfiguration {
    let environment: AppEnvironment
    let apiBaseURL: URL
    let requestTimeout: TimeInterval
    let resourceTimeout: TimeInterval

    static let shared = AppConfiguration()

    init(environment: AppEnvironment = .current) {
        self.environment = environment
        switch environment {
        case .development:
            if let override = ProcessInfo.processInfo.environment["TROPAYMENT_API_BASE"],
               let url = URL(string: override) {
                self.apiBaseURL = url
            } else {
                self.apiBaseURL = URL(string: "https://api.tropayment.com/api")!
            }
        case .staging:
            self.apiBaseURL = URL(string: "https://staging-api.tropayment.com/api")!
        case .production:
            self.apiBaseURL = URL(string: "https://api.tropayment.com/api")!
        }
        self.requestTimeout = 30
        self.resourceTimeout = 60
    }

    /// BCP-47 language code for `Accept-Language` header.
    var acceptLanguageCode: String {
        if let code = Locale.preferredLanguages.first?.split(separator: "-").first {
            return String(code)
        }
        return "en"
    }

    var websiteURL: URL {
        URL(string: "https://tropayment.com")!
    }

    var supportURL: URL {
        URL(string: "https://tropayment.com/contact")!
    }

    var privacyURL: URL {
        URL(string: "https://tropayment.com/page/privacy")!
    }
}
