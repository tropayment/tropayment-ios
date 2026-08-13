import SwiftUI

struct LoadingView: View {
    var message: LocalizedStringKey = "common.loading"

    var body: some View {
        VStack(spacing: TropaymentSpacing.md) {
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(1.2)
            Text(message)
                .font(TropaymentTypography.body())
                .foregroundStyle(TropaymentColors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message)
    }
}
