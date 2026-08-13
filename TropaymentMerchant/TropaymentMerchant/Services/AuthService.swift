import Foundation

@MainActor
final class AuthService {
    private let client: APIClient
    private let keychain: KeychainManager

    init(client: APIClient? = nil, keychain: KeychainManager = .shared) {
        self.client = client ?? APIClient.shared
        self.keychain = keychain
    }

    func captchaStatus(action: String) async throws -> CaptchaStatusResponse {
        try await client.request(
            .get("captcha-status", query: [URLQueryItem(name: "action", value: action)])
        )
    }

    func login(email: String, password: String, captchaToken: String? = nil) async throws -> LoginResponse {
        let body = LoginRequest(email: email, password: password, captchaToken: captchaToken)
        return try await client.request(.post("login", body: body))
    }

    func verify2FA(code: String, captchaToken: String? = nil) async throws -> LoginResponse {
        let body = TwoFactorVerifyRequest(code: code, captchaToken: captchaToken)
        return try await client.request(.post("v1/2fa/verify", body: body, auth: true))
    }

    func fetchCurrentUser() async throws -> MerchantUser {
        try await client.request(.get("v1/me", auth: true))
    }

    func logout() async {
        do {
            try await client.requestVoid(.post("v1/logout", body: EmptyBody(), auth: true))
        } catch {
            #if DEBUG
            print("[AuthService] Logout API failed: \(error.localizedDescription)")
            #endif
        }
        keychain.clearSession()
    }

    func forgotPassword(email: String) async throws -> MessageResponse {
        try await client.request(.post("forgot-password", body: ForgotPasswordRequest(email: email)))
    }

    func persistToken(_ token: String, kind: AuthTokenKind = .session) throws {
        try keychain.saveToken(token, kind: kind)
    }

    func savePendingTwoFactor(user: MerchantUser, token: String) throws {
        try keychain.saveToken(token, kind: .twoFactorPending)
        try keychain.savePendingUser(user)
    }

    func clearSession() {
        keychain.clearSession()
    }
}

private struct EmptyBody: Encodable {}
