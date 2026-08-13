import Foundation
import Security

enum KeychainError: Error {
    case unexpectedStatus(OSStatus)
    case dataConversionFailed
}

enum AuthTokenKind {
    case session
    case twoFactorPending
}

/// Secure storage for Sanctum tokens and minimal pending-2FA user snapshot.
final class KeychainManager {
    static let shared = KeychainManager()

    private let service = "com.tropayment.merchant"
    private let sessionAccount = "sanctum_session_token"
    private let pendingAccount = "sanctum_2fa_pending_token"
    private let pendingUserAccount = "pending_2fa_user"

    private init() {}

    // MARK: - Tokens

    func saveToken(_ token: String, kind: AuthTokenKind) throws {
        let account = accountName(for: kind)
        try writeData(Data(token.utf8), account: account)
        if kind == .session {
            try deleteItem(account: pendingAccount)
            try deleteItem(account: pendingUserAccount)
        }
    }

    func readToken(kind: AuthTokenKind) -> String? {
        readString(account: accountName(for: kind))
    }

    /// Token used for authenticated API requests (session preferred over pending).
    func readAuthToken() -> String? {
        readString(account: sessionAccount) ?? readString(account: pendingAccount)
    }

    var hasSessionToken: Bool {
        readString(account: sessionAccount) != nil
    }

    var hasPendingTwoFactorToken: Bool {
        readString(account: pendingAccount) != nil
    }

    var hasToken: Bool {
        hasSessionToken || hasPendingTwoFactorToken
    }

    // MARK: - Pending 2FA user snapshot

    func savePendingUser(_ user: MerchantUser) throws {
        let data = try JSONEncoder.api.encode(user)
        try writeData(data, account: pendingUserAccount)
    }

    func readPendingUser() -> MerchantUser? {
        guard let data = readData(account: pendingUserAccount) else { return nil }
        return try? JSONDecoder.api.decode(MerchantUser.self, from: data)
    }

    func clearSession() {
        try? deleteItem(account: sessionAccount)
        try? deleteItem(account: pendingAccount)
        try? deleteItem(account: pendingUserAccount)
    }

    func clearPendingTwoFactor() {
        try? deleteItem(account: pendingAccount)
        try? deleteItem(account: pendingUserAccount)
    }

    // MARK: - Private helpers

    private func accountName(for kind: AuthTokenKind) -> String {
        switch kind {
        case .session: return sessionAccount
        case .twoFactorPending: return pendingAccount
        }
    }

    private func writeData(_ data: Data, account: String) throws {
        try deleteItem(account: account)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }

    private func readData(account: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else { return nil }
        return item as? Data
    }

    private func readString(account: String) -> String? {
        guard let data = readData(account: account) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private func deleteItem(account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
}
