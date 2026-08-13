import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: TropaymentSpacing.lg) {
                    brandingHeader
                    loginCard
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, TropaymentSpacing.xl)
                .frame(minHeight: proxy.size.height)
            }
            .background(TropaymentColors.background(for: colorScheme).ignoresSafeArea())
        }
        .task { await viewModel.loadCaptchaStatus() }
        .sheet(isPresented: $viewModel.showForgotPassword) {
            ForgotPasswordView(viewModel: viewModel)
        }
    }

    private var horizontalPadding: CGFloat {
        horizontalSizeClass == .regular ? TropaymentSpacing.xxl : TropaymentSpacing.lg
    }

    private var brandingHeader: some View {
        VStack(spacing: TropaymentSpacing.sm) {
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .accessibilityLabel(String(localized: "app.name"))

            Text("app.name")
                .font(TropaymentTypography.largeTitle())
                .multilineTextAlignment(.center)

            Text("auth.subtitle")
                .font(TropaymentTypography.body())
                .foregroundStyle(TropaymentColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, TropaymentSpacing.lg)
    }

    private var loginCard: some View {
        Card {
            VStack(alignment: .leading, spacing: TropaymentSpacing.md) {
                Text("auth.sign_in")
                    .font(TropaymentTypography.title())

                if let error = viewModel.errorMessage {
                    ErrorBanner(message: error)
                }

                if viewModel.requiresCaptcha {
                    CaptchaNotice(siteKey: viewModel.captchaSiteKey)
                }

                TropaymentTextField(
                    title: "auth.email",
                    text: $viewModel.email,
                    errorMessage: viewModel.emailError,
                    keyboardType: .emailAddress,
                    textContentType: .emailAddress
                )

                TropaymentTextField(
                    title: "auth.password",
                    text: $viewModel.password,
                    errorMessage: viewModel.passwordError,
                    textContentType: .password,
                    isSecure: true
                )

                Button("auth.forgot_password") {
                    viewModel.forgotPasswordEmail = viewModel.email
                    viewModel.showForgotPassword = true
                }
                .font(TropaymentTypography.caption())
                .foregroundStyle(TropaymentColors.brandPrimary)

                PrimaryButton(
                    title: "auth.sign_in",
                    isLoading: viewModel.isLoading,
                    action: { Task { await viewModel.signIn() } }
                )
                .padding(.top, TropaymentSpacing.xs)
            }
        }
        .frame(maxWidth: 480)
        .frame(maxWidth: .infinity)
    }
}

private struct ErrorBanner: View {
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: TropaymentSpacing.sm) {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(TropaymentColors.danger)
            Text(message)
                .font(TropaymentTypography.caption())
                .foregroundStyle(TropaymentColors.danger)
        }
        .padding(TropaymentSpacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: TropaymentSpacing.cornerRadius, style: .continuous)
                .fill(TropaymentColors.danger.opacity(0.12))
        )
    }
}

private struct CaptchaNotice: View {
    let siteKey: String?

    var body: some View {
        HStack(alignment: .top, spacing: TropaymentSpacing.sm) {
            Image(systemName: "shield.lefthalf.filled")
                .foregroundStyle(TropaymentColors.warning)
            Text("auth.captcha_notice")
                .font(TropaymentTypography.caption())
                .foregroundStyle(TropaymentColors.textSecondary)
        }
        .padding(TropaymentSpacing.sm)
        .background(
            RoundedRectangle(cornerRadius: TropaymentSpacing.cornerRadius, style: .continuous)
                .fill(TropaymentColors.warning.opacity(0.12))
        )
        .accessibilityLabel(String(localized: "auth.captcha_notice"))
    }
}

#Preview {
    let session = AppSession()
    LoginView()
        .environmentObject(session)
        .environmentObject(AuthViewModel(session: session))
}
