import Foundation
import Combine

enum AuthPhase: Equatable {
    case launching
    case unauthenticated
    case awaitingTwoFactor(user: MerchantUser)
    case authenticated(user: MerchantUser)
}

@MainActor
final class AppSession: ObservableObject {
    @Published private(set) var phase: AuthPhase = .launching
    @Published var globalError: String?

    private let authService: AuthService
    private let keychain: KeychainManager

    private var unauthorizedObserver: NSObjectProtocol?

    init(authService: AuthService? = nil, keychain: KeychainManager = .shared) {
        self.authService = authService ?? AuthService()
        self.keychain = keychain
        unauthorizedObserver = NotificationCenter.default.addObserver(
            forName: .apiUnauthorized,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.handleUnauthorized()
            }
        }
    }

    deinit {
        if let unauthorizedObserver {
            NotificationCenter.default.removeObserver(unauthorizedObserver)
        }
    }

    var currentUser: MerchantUser? {
        if case .authenticated(let user) = phase { return user }
        if case .awaitingTwoFactor(let user) = phase { return user }
        return nil
    }

    var isAuthenticated: Bool {
        if case .authenticated = phase { return true }
        return false
    }

    func bootstrap() async {
        phase = .launching

        if keychain.hasPendingTwoFactorToken {
            if let user = keychain.readPendingUser() {
                phase = .awaitingTwoFactor(user: user)
                return
            }
            keychain.clearPendingTwoFactor()
        }

        guard keychain.hasSessionToken else {
            phase = .unauthenticated
            return
        }

        await validateStoredSession()
    }

    func validateStoredSession() async {
        phase = .launching
        do {
            let user = try await authService.fetchCurrentUser()
            phase = .authenticated(user: user)
        } catch let error as APIError where error.isUnauthorized {
            authService.clearSession()
            phase = .unauthenticated
        } catch {
            authService.clearSession()
            phase = .unauthenticated
            globalError = error.localizedDescription
        }
    }

    func handleUnauthorized() {
        authService.clearSession()
        phase = .unauthenticated
        globalError = String(localized: "error.session_expired")
    }

    func completeLogin(response: LoginResponse) throws {
        guard let token = response.token, !token.isEmpty else {
            throw APIError.validation(message: String(localized: "error.missing_token"), fieldErrors: [:], requiresCaptcha: false)
        }
        try authService.persistToken(token, kind: .session)
        keychain.clearPendingTwoFactor()
        if let user = response.user {
            phase = .authenticated(user: user)
        } else {
            Task { await validateStoredSession() }
        }
    }

    func requireTwoFactor(user: MerchantUser, token: String) throws {
        try authService.savePendingTwoFactor(user: user, token: token)
        phase = .awaitingTwoFactor(user: user)
    }

    func completeTwoFactor(response: LoginResponse) throws {
        try completeLogin(response: response)
    }

    func signOut() async {
        await authService.logout()
        phase = .unauthenticated
    }

    func cancelTwoFactor() {
        authService.clearSession()
        phase = .unauthenticated
    }
}
