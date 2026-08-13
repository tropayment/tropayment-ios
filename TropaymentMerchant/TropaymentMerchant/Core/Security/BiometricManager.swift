import Foundation
import LocalAuthentication

enum BiometricType {
    case none
    case touchID
    case faceID
}

/// Foundation for Phase 10 — optional app unlock with biometrics.
final class BiometricManager {
    static let shared = BiometricManager()

    private init() {}

    var biometricType: BiometricType {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        switch context.biometryType {
        case .faceID: return .faceID
        case .touchID: return .touchID
        default: return .none
        }
    }

    var isAvailable: Bool {
        biometricType != .none
    }

    func authenticate(reason: String) async throws -> Bool {
        let context = LAContext()
        context.localizedCancelTitle = String(localized: "common.cancel")
        return try await context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: reason
        )
    }
}
