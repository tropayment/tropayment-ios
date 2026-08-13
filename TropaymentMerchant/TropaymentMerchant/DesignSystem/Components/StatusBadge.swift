import SwiftUI

enum StatusBadgeStyle {
    case pending, confirming, paid, expired, cancelled, failed, neutral

    var title: LocalizedStringKey {
        switch self {
        case .pending: return "status.pending"
        case .confirming: return "status.confirming"
        case .paid: return "status.paid"
        case .expired: return "status.expired"
        case .cancelled: return "status.cancelled"
        case .failed: return "status.failed"
        case .neutral: return "status.neutral"
        }
    }

    var color: Color {
        switch self {
        case .pending: return TropaymentColors.warning
        case .confirming: return .blue
        case .paid: return TropaymentColors.success
        case .expired, .cancelled: return TropaymentColors.textSecondary
        case .failed: return TropaymentColors.danger
        case .neutral: return TropaymentColors.brandPrimary
        }
    }
}

struct StatusBadge: View {
    let style: StatusBadgeStyle

    var body: some View {
        Text(style.title)
            .font(TropaymentTypography.caption(.semibold))
            .foregroundStyle(style.color)
            .padding(.horizontal, TropaymentSpacing.sm)
            .padding(.vertical, TropaymentSpacing.xxs)
            .background(
                Capsule(style: .continuous)
                    .fill(style.color.opacity(0.14))
            )
    }
}
