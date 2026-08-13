import SwiftUI

enum TropaymentColors {
    static let brandPrimary = Color(red: 0.427, green: 0.157, blue: 0.851) // #6D28D9
    static let brandPrimaryDark = Color(red: 0.345, green: 0.118, blue: 0.690)
    static let backgroundDark = Color(red: 0.035, green: 0.035, blue: 0.059) // #09090F
    static let backgroundLight = Color(red: 0.965, green: 0.969, blue: 0.992)
    static let surfaceDark = Color(red: 0.086, green: 0.086, blue: 0.122)
    static let surfaceLight = Color.white
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let success = Color(red: 0.133, green: 0.773, blue: 0.369)
    static let warning = Color(red: 0.961, green: 0.620, blue: 0.043)
    static let danger = Color(red: 0.937, green: 0.267, blue: 0.267)
    static let border = Color.primary.opacity(0.12)

    static func background(for scheme: ColorScheme) -> Color {
        scheme == .dark ? backgroundDark : backgroundLight
    }

    static func surface(for scheme: ColorScheme) -> Color {
        scheme == .dark ? surfaceDark : surfaceLight
    }
}
