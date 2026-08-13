import SwiftUI

struct TwoFactorView: View {
    @ObservedObject var viewModel: AuthViewModel
    let user: MerchantUser
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: TropaymentSpacing.lg) {
            VStack(spacing: TropaymentSpacing.sm) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(TropaymentColors.brandPrimary)
                    .accessibilityHidden(true)

                Text("auth.two_factor_title")
                    .font(TropaymentTypography.title())

                Text("auth.two_factor_message")
                    .font(TropaymentTypography.body())
                    .foregroundStyle(TropaymentColors.textSecondary)
                    .multilineTextAlignment(.center)

                Text(user.email)
                    .font(TropaymentTypography.caption())
                    .foregroundStyle(TropaymentColors.textSecondary)
            }
            .padding(.top, TropaymentSpacing.xxl)

            Card {
                VStack(spacing: TropaymentSpacing.md) {
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(TropaymentTypography.caption())
                            .foregroundStyle(TropaymentColors.danger)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    TropaymentTextField(
                        title: "auth.verification_code",
                        text: $viewModel.twoFactorCode,
                        errorMessage: viewModel.codeError,
                        keyboardType: .numberPad
                    )
                    .onChange(of: viewModel.twoFactorCode) { newValue in
                        let filtered = newValue.filter(\.isNumber)
                        viewModel.twoFactorCode = String(filtered.prefix(6))
                    }

                    PrimaryButton(
                        title: "auth.verify",
                        isLoading: viewModel.isLoading,
                        isDisabled: viewModel.twoFactorCode.count != 6,
                        action: { Task { await viewModel.verifyTwoFactor() } }
                    )

                    SecondaryButton(title: "auth.back_to_login") {
                        viewModel.cancelTwoFactor()
                    }
                }
            }
            .frame(maxWidth: 480)

            Spacer()
        }
        .padding(TropaymentSpacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(TropaymentColors.background(for: colorScheme).ignoresSafeArea())
    }
}
