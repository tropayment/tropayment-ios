import SwiftUI

struct ErrorView: View {
    let message: String
    var retryTitle: LocalizedStringKey = "common.try_again"
    let onRetry: (() -> Void)?

    var body: some View {
        VStack(spacing: TropaymentSpacing.lg) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundStyle(TropaymentColors.warning)
                .accessibilityHidden(true)

            Text(message)
                .font(TropaymentTypography.body())
                .multilineTextAlignment(.center)
                .foregroundStyle(TropaymentColors.textSecondary)
                .padding(.horizontal, TropaymentSpacing.lg)

            if let onRetry {
                SecondaryButton(title: retryTitle, action: onRetry)
                    .frame(maxWidth: 280)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(TropaymentSpacing.lg)
    }
}
