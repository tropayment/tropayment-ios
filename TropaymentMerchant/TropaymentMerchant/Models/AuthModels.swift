import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
    let captchaToken: String?

    enum CodingKeys: String, CodingKey {
        case email, password
        case captchaToken = "cf-turnstile-response"
    }
}

struct TwoFactorVerifyRequest: Encodable {
    let code: String
    let captchaToken: String?

    enum CodingKeys: String, CodingKey {
        case code
        case captchaToken = "cf-turnstile-response"
    }
}

struct ForgotPasswordRequest: Encodable {
    let email: String
}

struct LoginResponse: Decodable {
    let user: MerchantUser?
    let token: String?
    let requires2FA: Bool?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case user, token, message
        case requires2FA = "requires_2fa"
    }
}

struct CaptchaStatusResponse: Decodable {
    let requiresCaptcha: Bool
    let sitekey: String?

    enum CodingKeys: String, CodingKey {
        case requiresCaptcha = "requires_captcha"
        case sitekey
    }
}

struct MessageResponse: Decodable {
    let message: String
}
