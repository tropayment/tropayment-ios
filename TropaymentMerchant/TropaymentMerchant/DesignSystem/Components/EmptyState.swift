import SwiftUI

struct EmptyStateView: View {
    let title: LocalizedStringKey
    let message: LocalizedStringKey
    var systemImage: String = "tray"

    var body: some View {
        VStack(spacing: TropaymentSpacing.md) {
            Image(systemName: systemImage)
                .font(.system(size: 44))
                .foregroundStyle(TropaymentColors.brandPrimary.opacity(0.7))
                .accessibilityHidden(true)

            Text(title)
                .font(TropaymentTypography.title())

            Text(message)
                .font(TropaymentTypography.body())
                .foregroundStyle(TropaymentColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(TropaymentSpacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
