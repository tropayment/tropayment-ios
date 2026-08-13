import SwiftUI

enum TropaymentTypography {
    static func largeTitle(_ weight: Font.Weight = .bold) -> Font {
        .system(.largeTitle, design: .rounded).weight(weight)
    }

    static func title(_ weight: Font.Weight = .semibold) -> Font {
        .system(.title2, design: .rounded).weight(weight)
    }

    static func headline(_ weight: Font.Weight = .semibold) -> Font {
        .system(.headline, design: .rounded).weight(weight)
    }

    static func body(_ weight: Font.Weight = .regular) -> Font {
        .system(.body, design: .default).weight(weight)
    }

    static func caption(_ weight: Font.Weight = .medium) -> Font {
        .system(.caption, design: .default).weight(weight)
    }

    static func numeric(_ size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}
