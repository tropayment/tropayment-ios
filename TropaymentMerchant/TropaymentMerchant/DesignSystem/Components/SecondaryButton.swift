import SwiftUI

struct SecondaryButton: View {
    let title: LocalizedStringKey
    var isDisabled: Bool = false
    let action: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(TropaymentTypography.headline())
                .frame(maxWidth: .infinity)
                .frame(height: TropaymentSpacing.buttonHeight)
                .foregroundStyle(TropaymentColors.brandPrimary)
                .background(
                    RoundedRectangle(cornerRadius: TropaymentSpacing.cornerRadius, style: .continuous)
                        .stroke(TropaymentColors.border, lineWidth: 1)
                        .background(
                            RoundedRectangle(cornerRadius: TropaymentSpacing.cornerRadius, style: .continuous)
                                .fill(TropaymentColors.surface(for: colorScheme))
                        )
                )
        }
        .disabled(isDisabled)
    }
}
