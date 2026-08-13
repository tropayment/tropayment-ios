import SwiftUI

struct TransactionsPlaceholderView: View {
    var body: some View {
        EmptyStateView(
            title: "tab.transactions",
            message: "placeholder.coming_phase_6",
            systemImage: "list.bullet.rectangle"
        )
        .navigationTitle(String(localized: "tab.transactions"))
    }
}
