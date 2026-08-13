import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            VStack(spacing: TropaymentSpacing.lg) {
                if let message = viewModel.forgotPasswordMessage {
                    Card {
                        VStack(alignment: .leading, spacing: TropaymentSpacing.sm) {
                            Label("auth.reset_email_sent", systemImage: "envelope.fill")
                                .font(TropaymentTypography.headline())
                                .foregroundStyle(TropaymentColors.success)
                            Text(message)
                                .font(TropaymentTypography.body())
                                .foregroundStyle(TropaymentColors.textSecondary)
                        }
                    }
                } else {
                    Card {
                        VStack(alignment: .leading, spacing: TropaymentSpacing.md) {
                            Text("auth.forgot_password_title")
                                .font(TropaymentTypography.title())

                            Text("auth.forgot_password_message")
                                .font(TropaymentTypography.body())
                                .foregroundStyle(TropaymentColors.textSecondary)

                            TropaymentTextField(
                                title: "auth.email",
                                text: $viewModel.forgotPasswordEmail,
                                errorMessage: viewModel.emailError,
                                keyboardType: .emailAddress,
                                textContentType: .emailAddress
                            )

                            PrimaryButton(
                                title: "auth.send_reset_link",
                                isLoading: viewModel.isLoading,
                                action: { Task { await viewModel.sendForgotPassword() } }
                            )
                        }
                    }
                }

                Spacer()
            }
            .padding(TropaymentSpacing.lg)
            .background(TropaymentColors.background(for: colorScheme).ignoresSafeArea())
            .navigationTitle(String(localized: "auth.forgot_password"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("common.close") { dismiss() }
                }
            }
        }
    }
}
