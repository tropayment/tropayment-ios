import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var twoFactorCode = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var fieldErrors: [String: String] = [:]
    @Published var requiresCaptcha = false
    @Published var captchaSiteKey: String?
    @Published var showForgotPassword = false
    @Published var forgotPasswordEmail = ""
    @Published var forgotPasswordMessage: String?

    private let authService: AuthService
    private let session: AppSession
    private let keychain: KeychainManager

    init(authService: AuthService? = nil, session: AppSession, keychain: KeychainManager = .shared) {
        self.authService = authService ?? AuthService()
        self.session = session
        self.keychain = keychain
    }

    var emailError: String? { fieldErrors["email"] }
    var passwordError: String? { fieldErrors["password"] }
    var codeError: String? { fieldErrors["code"] }

    func loadCaptchaStatus() async {
        do {
            let status = try await authService.captchaStatus(action: "login")
            requiresCaptcha = status.requiresCaptcha
            captchaSiteKey = status.sitekey
        } catch {
            #if DEBUG
            print("[AuthViewModel] captcha status: \(error.localizedDescription)")
            #endif
        }
    }

    func signIn() async {
        guard validateLogin() else { return }
        isLoading = true
        errorMessage = nil
        fieldErrors = [:]
        defer { isLoading = false }

        do {
            let response = try await authService.login(
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )

            if response.requires2FA == true, let user = response.user, let token = response.token {
                try session.requireTwoFactor(user: user, token: token)
                return
            }

            try session.completeLogin(response: response)
            password = ""
        } catch let error as APIError {
            handleAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func verifyTwoFactor() async {
        guard twoFactorCode.count == 6 else {
            fieldErrors["code"] = String(localized: "auth.error.code_length")
            return
        }
        isLoading = true
        errorMessage = nil
        fieldErrors = [:]
        defer { isLoading = false }

        do {
            let response = try await authService.verify2FA(code: twoFactorCode)
            try session.completeTwoFactor(response: response)
            twoFactorCode = ""
            password = ""
        } catch let error as APIError {
            handleAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func sendForgotPassword() async {
        let trimmed = forgotPasswordEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            fieldErrors["email"] = String(localized: "auth.error.email_required")
            return
        }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let response = try await authService.forgotPassword(email: trimmed)
            forgotPasswordMessage = response.message
        } catch let error as APIError {
            handleAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func cancelTwoFactor() {
        session.cancelTwoFactor()
        twoFactorCode = ""
    }

    private func validateLogin() -> Bool {
        fieldErrors = [:]
        var valid = true
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            fieldErrors["email"] = String(localized: "auth.error.email_required")
            valid = false
        }
        if password.isEmpty {
            fieldErrors["password"] = String(localized: "auth.error.password_required")
            valid = false
        }
        return valid
    }

    private func handleAPIError(_ error: APIError) {
        errorMessage = error.localizedDescription
        for (key, messages) in error.fieldErrors {
            fieldErrors[key] = messages.first
        }
        if case .validation(_, _, let requiresCaptcha) = error, requiresCaptcha {
            self.requiresCaptcha = true
        }
        if error.isUnauthorized, session.isAuthenticated || keychain.hasSessionToken {
            session.handleUnauthorized()
        }
    }
}
