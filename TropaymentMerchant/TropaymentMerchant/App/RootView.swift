import SwiftUI

struct RootView: View {
    @EnvironmentObject private var session: AppSession
    @EnvironmentObject private var authViewModel: AuthViewModel

    var body: some View {
        Group {
            switch session.phase {
            case .launching:
                LoadingView(message: "common.launching")
            case .unauthenticated:
                LoginView()
            case .awaitingTwoFactor(let user):
                TwoFactorView(viewModel: authViewModel, user: user)
            case .authenticated(let user):
                MainTabView(user: user)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: session.phase)
        .task {
            if case .launching = session.phase {
                await session.bootstrap()
            }
        }
        .alert(
            String(localized: "error.session_expired"),
            isPresented: Binding(
                get: { session.globalError != nil },
                set: { if !$0 { session.globalError = nil } }
            )
        ) {
            Button(String(localized: "common.close"), role: .cancel) {
                session.globalError = nil
            }
        } message: {
            if let message = session.globalError {
                Text(message)
            }
        }
    }
}
