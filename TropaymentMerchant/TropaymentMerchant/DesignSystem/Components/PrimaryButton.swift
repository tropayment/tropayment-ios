import SwiftUI

struct PrimaryButton: View {
    let title: LocalizedStringKey
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: TropaymentSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                }
                Text(title)
                    .font(TropaymentTypography.headline())
            }
            .frame(maxWidth: .infinity)
            .frame(height: TropaymentSpacing.buttonHeight)
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: TropaymentSpacing.cornerRadius, style: .continuous)
                    .fill(isDisabled || isLoading ? TropaymentColors.brandPrimary.opacity(0.5) : TropaymentColors.brandPrimary)
            )
        }
        .disabled(isDisabled || isLoading)
        .accessibilityAddTraits(.isButton)
    }
}
