import Foundation

struct MerchantUser: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let email: String
    let role: String?
    let kycStatus: String?
    let emailVerified: Bool?
    let twoFactorEnabled: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, email, role
        case kycStatus = "kyc_status"
        case emailVerified = "email_verified"
        case twoFactorEnabled = "two_factor_enabled"
    }

    var displayName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? email : name
    }
}
