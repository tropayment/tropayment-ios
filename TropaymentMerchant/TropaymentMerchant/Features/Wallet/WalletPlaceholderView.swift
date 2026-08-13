import SwiftUI

struct WalletPlaceholderView: View {
    var body: some View {
        EmptyStateView(
            title: "tab.wallet",
            message: "placeholder.coming_phase_7",
            systemImage: "wallet.pass.fill"
        )
        .navigationTitle(String(localized: "tab.wallet"))
    }
}
