import SwiftUI

@main
struct TropaymentMerchantApp: App {
    @StateObject private var session: AppSession
    @StateObject private var authViewModel: AuthViewModel

    init() {
        let session = AppSession()
        _session = StateObject(wrappedValue: session)
        _authViewModel = StateObject(wrappedValue: AuthViewModel(session: session))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
                .environmentObject(authViewModel)
                .tint(TropaymentColors.brandPrimary)
        }
    }
}
